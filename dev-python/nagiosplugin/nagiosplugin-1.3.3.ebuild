# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A class library for writing nagios-compatible plugins"
HOMEPAGE="
	https://github.com/mpounsett/nagiosplugin/
	https://nagiosplugin.readthedocs.io/
	https://pypi.org/project/nagiosplugin/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx-rtd-theme
