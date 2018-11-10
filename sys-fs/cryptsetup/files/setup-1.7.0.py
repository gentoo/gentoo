import os
from distutils.core import setup, Extension

top_srcdir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

def get_ver():
    with open(os.path.join(top_srcdir, 'configure')) as f:
        for line in f:
            if line.startswith('PACKAGE_VERSION='):
                return line.split('=')[1].replace("'", '').strip()

module = Extension('pycryptsetup',
                   include_dirs=[os.path.join(top_srcdir, 'lib')],
                   extra_compile_args=['-include', os.path.join(top_srcdir, 'config.h')],
                   library_dirs=[os.path.join(top_srcdir, 'lib', '.libs')],
                   libraries=['cryptsetup'],
                   sources=['pycryptsetup.c'])

setup(name='pycryptsetup',
      version=get_ver(),
      ext_modules=[module])
