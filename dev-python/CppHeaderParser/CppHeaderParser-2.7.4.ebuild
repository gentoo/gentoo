# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Parse C++ header files and generate a data structure"
HOMEPAGE="https://senexcanis.com/open-source/cppheaderparser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/ply[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"
