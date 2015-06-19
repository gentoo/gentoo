#!/usr/bin/env python

from distutils.core import setup

setup(
    name = 'ris-linux',
    version = 'VERSION',
    scripts = [ 'binlsrv.py', 'decode.py', 'infparser.py', 'fixloader.py', 'modldr.py' ]
)
