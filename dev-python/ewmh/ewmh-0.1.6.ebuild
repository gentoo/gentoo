# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="An implementation of Extended Window Manager Hints, based on Xlib"
HOMEPAGE="https://github.com/parkouss/pyewmh https://pypi.python.org/pypi/ewmh"

LICENSE="LGPL-3"
SLOT="0"

KEYWORDS="amd64 x86"

RDEPEND="dev-python/python-xlib[${PYTHON_USEDEP}]"
