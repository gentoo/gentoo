#!/usr/bin/env python3
import re
import subprocess
import sys

def run(cmd, cwd):
    return subprocess.run(cmd, shell=True, cwd=cwd, capture_output=True, text=True).stdout

def main(src):
    name_path, name_url = {}, {}
    for line in run("git config -f .gitmodules --list", src).splitlines():
        key, _, value = line.partition("=")
        match = re.match(r"submodule\.(.+)\.(path|url)$", key)
        if match:
            (name_path if match.group(2) == "path" else name_url)[match.group(1)] = value

    path_sha = {}
    for line in run("git submodule status", src).splitlines():
        line = line[1:] if line[:1] in " +-" else line
        parts = line.split()
        if len(parts) >= 2:
            path_sha[parts[1]] = parts[0]

    rows = []
    for name, path in name_path.items():
        url, sha = name_url.get(name, ""), path_sha.get(path, "")
        owner_repo = re.sub(r"\.git$", "", re.sub(r"^(https?://github\.com/|git@github\.com:)", "", url))
        if url and sha and "github.com" in url and path.startswith("contrib/"):
            rows.append(f'\t"{path[len("contrib/"):]} {owner_repo} {sha}"')

    rows.sort()
    print("CH_SUBMODULES=(")
    print("\n".join(rows))
    print(")")
    print(f"# {len(rows)} submodules", file=sys.stderr)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(f"usage: {sys.argv[0]} <clickhouse-source-dir>")
    main(sys.argv[1])
