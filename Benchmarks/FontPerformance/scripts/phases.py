"""Per-phase CPU (main + other threads) from exported Time Profiler XML, averaged over several traces.

Usage: python3 scripts/phases.py sf:traces/a-sf,traces/b-sf ims:traces/a-ims,traces/b-ims
Each trace prefix expects <prefix>-tp.xml (time-profile) and <prefix>-sp.xml (os-signpost).
"""
import collections, statistics, sys, xml.etree.ElementTree as ET

FONT_LIBS = ('CoreText', 'libFontParser.dylib', 'libTrueTypeScaler.dylib')


def resolver(root):
    ids = {e.get('id'): e for e in root.iter() if e.get('id')}
    return lambda e: ids[e.get('ref')] if e is not None and e.get('ref') else e


def intervals(prefix):
    root = ET.parse(f'{prefix}-sp.xml').getroot(); res = resolver(root); out = []; open_ = {}
    for row in root.iter('row'):
        name, typ = res(row.find('signpost-name')), res(row.find('event-type'))
        if name is None or typ is None:
            continue
        t = int(res(row.find('event-time')).text)
        if typ.text == 'Begin':
            open_.setdefault(name.text, []).append(t)
        elif typ.text == 'End' and open_.get(name.text):
            out.append((open_[name.text].pop(), t, name.text))
    return sorted(out)


def phase_cpu(prefix):
    iv = intervals(prefix)
    root = ET.parse(f'{prefix}-tp.xml').getroot(); res = resolver(root)
    total, font = collections.Counter(), collections.Counter()
    for row in root.iter('row'):
        bt = row.find('backtrace')
        bt = res(bt if bt is not None else row.find('tagged-backtrace'))
        if bt is None:
            continue
        t = int(res(row.find('sample-time')).text)
        phase = next((n for b, e, n in iv if b <= t <= e), None)
        if phase is None:
            continue
        w = int(res(row.find('weight')).text) / 1e6
        total[phase] += w
        bins = {res(res(f).find('binary')).get('name') for f in bt.findall('frame') if res(res(f).find('binary')) is not None}
        if bins & set(FONT_LIBS):
            font[phase] += w
    return total, font, [n for _, _, n in iv]


def main():
    groups = {}
    order = []
    for arg in sys.argv[1:]:
        kind, prefixes = arg.split(':', 1)
        groups[kind] = [phase_cpu(p) for p in prefixes.split(',')]
        for _, _, names in groups[kind]:
            for n in names:
                if n not in order:
                    order.append(n)
    kinds = list(groups)
    header = f"{'phase':22}" + ''.join(f"{k + ' cpu':>14}{k + ' texte':>14}" for k in kinds)
    print(header + f"   (ms, moyenne de {len(groups[kinds[0]])} traces)")
    for phase in order:
        line = f'{phase:22}'
        for k in kinds:
            line += f"{statistics.mean(t[phase] for t, _, _ in groups[k]):14.0f}{statistics.mean(f[phase] for _, f, _ in groups[k]):14.0f}"
        print(line)


main()
