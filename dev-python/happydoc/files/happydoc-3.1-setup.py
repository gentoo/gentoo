#!/usr/bin/env python
#
# $Id$
#
# Time-stamp: <02/02/05 10:00:12 dhellmann>
#
# Copyright 2001 Doug Hellmann.
#
#
#                         All Rights Reserved
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby
# granted, provided that the above copyright notice appear in all
# copies and that both that copyright notice and this permission
# notice appear in supporting documentation, and that the name of Doug
# Hellmann not be used in advertising or publicity pertaining to
# distribution of the software without specific, written prior
# permission.
#
# DOUG HELLMANN DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN
# NO EVENT SHALL DOUG HELLMANN BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
# OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
"""Distutils setup file for HappyDoc

"""

__rcs_info__ = {
    #
    #  Creation Information
    #
    'module_name'  : '$RCSfile: happydoc-3.1-setup.py,v $',
    'rcs_id'       : '$Id$',
    'creator'      : 'Doug Hellmann <doug@hellfly.net>',
    'project'      : 'HappyDoc',
    'created'      : 'Sat, 03-Feb-2001 12:51:26 EST',

    #
    #  Current Information
    #
    'author'       : '$Author: neurogeek $',
    'version'      : '$Revision: 1.1 $',
    'date'         : '$Date: 2009/02/25 20:59:36 $',
}
try:
    __version__ = __rcs_info__['version'].split(' ')[1]
except:
    __version__ = '0.0'

#
# Import system modules
#
from distutils.core import setup
import string
import sys

#
# Import Local modules
#

#
# Module
#

BSD_LICENSE="""

                    Copyright 2001, 2002 Doug Hellmann.

                         All Rights Reserved

Permission to use, copy, modify, and distribute this software and
its documentation for any purpose and without fee is hereby
granted, provided that the above copyright notice appear in all
copies and that both that copyright notice and this permission
notice appear in supporting documentation, and that the name of Doug
Hellmann not be used in advertising or publicity pertaining to
distribution of the software without specific, written prior
permission.

DOUG HELLMANN DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN
NO EVENT SHALL DOUG HELLMANN BE LIABLE FOR ANY SPECIAL, INDIRECT OR
CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
"""

LONG_DESCRIPTION = """
  HappyDoc is a tool for extracting documentation from Python source
  code.  It differs from other such applications by the fact that it
  uses the parse tree for a module to derive the information used in
  its output, rather that importing the module directly.  This allows
  the user to generate documentation for modules which need special
  context to be imported.
"""


def cvsProductVersion(cvsVersionString='$Name:  $'):
    """Function to return the version number of the program.

    The value is taken from the CVS tag, assuming the tag has the form:

        rX_Y_Z

    Where X is the major version number, Y is the minor version
    number, and Z is the optional sub-minor version number.
    """
    cvs_version_parts=string.split(cvsVersionString)
    if len(cvs_version_parts) >= 3:
        app_version = string.strip(cvs_version_parts[1]).replace('_', '.')
        if app_version and app_version[0] == 'r':
            app_version = app_version[1:]
    else:
        app_version = 'WORKING'
    return app_version



if sys.platform == 'win32':
    platform_specific_scripts = ['happydocwin.py']
else:
    platform_specific_scripts = ['happydoc']

setup (
    name = 'HappyDoc',
    version = cvsProductVersion(),

    description = 'HappyDoc Automatic Documentation System',
    long_description = LONG_DESCRIPTION,

    author = 'Doug Hellmann',
    author_email = 'doug@hellfly.net',

    url = 'http://happydoc.sourceforge.net',
    licence = BSD_LICENSE,

    platforms = ('Any',),
    keywords = ('documentation', 'extraction', 'source', 'docstring', '__doc__'),

    packages = [ 'happydoclib',
                 'happydoclib.docset',
                 'happydoclib.docstring',
                 'happydoclib.docstring.StructuredText',
                 'happydoclib.parseinfo',
                 'happydoclib.parsers',
                 ],
    
    package_dir = { '': '.' },
    
    scripts = platform_specific_scripts,
    )

