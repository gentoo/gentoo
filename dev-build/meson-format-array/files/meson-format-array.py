#!/usr/bin/env python3
# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

import itertools
import shlex
import sys


def quote(s):
    """ Surround a value with quotes, escape embedded quotes.
    >>> quote("foo'bar")
    "'foo\\\\'bar'"
    """

    return "'" + s.replace("\\", "\\\\").replace("'", "\\'") + "'"


def format_array(args):
    """ Format shell-compatible expressions as a meson array.
    >>> format_array(['-O2 -pipe -DFOO="bar baz"'])
    "['-O2', '-pipe', '-DFOO=bar baz']"
    """

    # Split each argument according to shell rules
    args = (shlex.split(x) for x in args)

    # Flatten the resulting list of lists
    args = itertools.chain.from_iterable(args)

    # Add quotes and escape embedded quotes
    args = (quote(x) for x in args)

    # Format the result
    return "[" + ", ".join(args) + "]"


def main(args):
    print(format_array(args))


if __name__ == "__main__":
    main(sys.argv[1:])
