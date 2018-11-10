from distutils.core import setup, Extension
import os
import sys
 
old_filename = os.path.join("Perl", "RNA.py")
new_filename = os.path.join("Perl", "__init__.py")
if os.path.exists(old_filename):
    os.rename(old_filename, new_filename)
 
extra_link_args = []
 
extension = Extension("_RNA",
                      ["Perl/RNA_wrap.c"],
                      libraries=['RNA'],
                      library_dirs=['lib'],
                      extra_link_args=extra_link_args
                      )
 
setup(name="RNA",
      version="2.1.1",
      description="Vienna RNA",
      author="Ivo Hofacker, Institute for Theoretical Chemistry, University of Vienna",
      url="http://www.tbi.univie.ac.at/RNA/",
      package_dir = {'RNA':'Perl'},
      packages = ['RNA'],
      ext_modules=[extension],
      )
