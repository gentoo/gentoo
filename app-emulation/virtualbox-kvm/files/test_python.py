#!/usr/bin/python3

# Smoke test for python:
# Test if the python bindings have been built and if python is crashing when creating a manager

def test_module_was_built():
    import os
    assert os.path.isfile(os.getenv('VBOX_PROGRAM_PATH') + '/VBoxPython3.so')

def test_VirtualBoxManager():
    from vboxapi import VirtualBoxManager
    try:
        manager = VirtualBoxManager()
    except:
        # if it reaches here, it did not crash
        pass
