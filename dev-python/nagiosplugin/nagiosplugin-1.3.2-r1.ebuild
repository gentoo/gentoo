# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..10} )

inherit distutils-r1

DESCRIPTION="A class library for writing nagios-compatible plugins"
HOMEPAGE="https://github.com/mpounsett/nagiosplugin https://nagiosplugin.readthedocs.io"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="ZPL"
SLOT="0"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx_rtd_theme
