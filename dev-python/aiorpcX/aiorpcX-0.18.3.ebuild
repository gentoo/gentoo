# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Generic async RPC implementation, including JSON-RPC"
HOMEPAGE="https://pypi.org/project/aiorpcX/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-python/attrs-17.3.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

DOCS=( README.rst )
