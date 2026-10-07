import argparse
import json
from pathlib import Path


def generate_release_notes(manifest_path: Path) -> str:
    versions = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not isinstance(versions, dict) or not versions:
        raise ValueError("Package versions must be a nonempty JSON object.")

    lines = []
    for name, version in versions.items():
        if not name.strip():
            raise ValueError("Artifact names must be nonempty.")
        if not isinstance(version, str) or not version.strip():
            raise ValueError(f"Version for {name!r} must be a nonempty string.")
        lines.append(f"`{name}`: {version}")

    return "### Versions\n\n" + "\n\n".join(lines) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate artifact release notes.")
    parser.add_argument("manifest", type=Path, help="Path to package-versions.json")
    args = parser.parse_args()
    try:
        notes = generate_release_notes(args.manifest)
    except (OSError, ValueError) as error:
        parser.exit(1, f"error: {error}\n")
    print(notes, end="")


if __name__ == "__main__":
    main()
