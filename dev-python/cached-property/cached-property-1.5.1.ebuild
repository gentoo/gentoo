# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1

DESCRIPTION="A cached-property for decorating methods in classes"
HOMEPAGE="https://github.com/pydanny/cached-property"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

DEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
	)"
RDEPEND=""

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	dodoc README.rst HISTORY.rst CONTRIBUTING.rst AUTHORS.rst
}
