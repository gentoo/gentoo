# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Parse C++ header files and generate a data structure"
HOMEPAGE="
	https://senexcanis.com/open-source/cppheaderparser/
	https://pypi.org/project/CppHeaderParser/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/ply[${PYTHON_USEDEP}]
"
