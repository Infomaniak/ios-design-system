import sys, json, statistics as st
rows = {}
for line in open(sys.argv[1]):
    k, j = line.split(' ', 1); rows.setdefault(k, []).append(json.loads(j))
keys = sorted({x for r in rows.values() for d in r for x in d})
print(f"{'metric':40}{'SF (median)':>14}{'Infomaniak (median)':>22}{'delta':>10}   n={len(rows.get('sf',[]))}/{len(rows.get('ims',[]))}")
for key in keys:
    m = {k: st.median([d[key] for d in v if key in d]) if any(key in d for d in v) else None for k, v in rows.items()}
    sf, ims = m.get('sf'), m.get('ims')
    delta = f"{(ims/sf-1)*100:+.0f}%" if sf and ims else ""
    f = lambda x: "-" if x is None else f"{x:.2f}"
    print(f"{key:40}{f(sf):>14}{f(ims):>22}{delta:>10}")
