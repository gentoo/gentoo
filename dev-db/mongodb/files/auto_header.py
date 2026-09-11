#!/usr/bin/env python3

# derived from bazel/wrapper_hook/wrapper_hook.py
# we are only running the auto_header portions of the script

import sys
import os
import shutil
from pathlib import Path

REPO_ROOT = Path(sys.argv[1])
sys.path.append(str(REPO_ROOT))

os.environ["RG_PATH"] = shutil.which("rg")
os.environ["FORCE_NO_FD"] = "1"

def main():
    from bazel.auto_header.auto_header import gen_auto_headers
    from bazel.auto_header.gen_all_headers import spawn_all_headers_thread
    th_all_header, hdr_state_all_header = spawn_all_headers_thread(REPO_ROOT)

    auto_hdr_state = gen_auto_headers(REPO_ROOT)
    th_all_header.join()

    if not hdr_state_all_header["ok"]:
        print(f'[all_headers] failed: {hdr_state_all_header["err"]!r}')
        sys.exit(1)

    if not auto_hdr_state["ok"]:
        print(f'[auto_headers] failed: {auto_hdr_state["err"]!r}')
        sys.exit(1)

if __name__ == "__main__":
    main()
