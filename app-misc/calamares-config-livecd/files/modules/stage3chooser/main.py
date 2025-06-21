#!/usr/bin/env python3
import os
import subprocess
import sys
import libcalamares

SCRIPT_PATH = "/usr/bin/stage3chooser.py"

def _check_parent_alive():
    if os.getppid() == 1:
        sys.exit(1)

def run():
    if not os.path.exists(SCRIPT_PATH):
        return f"Error: script not found at {SCRIPT_PATH}"

    try:
        result = subprocess.run(
            [sys.executable, SCRIPT_PATH],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        libcalamares.utils.debug("Stage3 script stdout: " + result.stdout.decode())
        return None
    except subprocess.CalledProcessError as e:
        libcalamares.utils.warning("Stage3 script failed: " + e.stderr.decode())
        return f"Stage3 installer failed with exit code {e.returncode}"
