# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="Library for creating and manipulating HTML documents using an elegant DOM API"
HOMEPAGE="https://github.com/Knio/dominate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

distutils_enable_tests pytest
