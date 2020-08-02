# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Python library providing a few tools handling SemVer in Python"
HOMEPAGE="https://pypi.org/project/semantic_version/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
#SRC_URI="https://github.com/rbarrois/python-semanticversion/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest
