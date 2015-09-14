# Licensed under a 3-clause BSD style license - see LICENSE.rst

"""
Handle loading ply package from system or from the bundled copy
"""

import imp
from distutils.version import StrictVersion


def _find_module(name, path=None):
    """
    Alternative to `imp.find_module` that can also search in subpackages.
    """

    parts = name.split('.')

    for part in parts:
        if path is not None:
            path = [path]

        fh, path, descr = imp.find_module(part, path)

    return fh, path, descr

_PLY_MIN_VERSION = StrictVersion('3.4')

# Update this to prevent Astropy from using its bundled copy of ply
# (but only if some other version of at least _PLY_MIN_VERSION can
# be provided)
_PLY_SEARCH_PATH = ['ply']


for mod_name in _PLY_SEARCH_PATH:
    try:
        mod_info = _find_module(mod_name)
        #mod_lex_info = _find_module(mod_name + '.lex')
    except ImportError:
        continue

    mod = imp.load_module(__name__, *mod_info)
    #mod_lex = imp.load_module(__name__ + '.lex', *mod_lex_info)

    try:
    #    if StrictVersion(mod_lex.__version__) >= _PLY_MIN_VERSION:
    #        break
        break
    except (AttributeError, ValueError):
        # Attribute error if the ply module isn't what it should be and doesn't
        # have a .__version__; ValueError if the version string exists but is
        # somehow bogus/unparseable
        continue
else:
    raise ImportError(
        "Astropy requires the 'ply' module of minimum version {0}; "
        "normally this is bundled with the astropy package so if you get "
        "this warning consult the packager of your Astropy "
        "distribution.".format(_PLY_MIN_VERSION))
