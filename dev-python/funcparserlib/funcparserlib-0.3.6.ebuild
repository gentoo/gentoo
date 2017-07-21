# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="Recursive descent parsing library based on functional combinators"
HOMEPAGE="https://code.google.com/p/funcparserlib/ https://pypi.python.org/pypi/funcparserlib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	local m=unittest
	cd "${BUILD_DIR}"/lib || die
	"${PYTHON}" -m ${m} discover || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( doc/*.md )
	distutils-r1_python_install_all
}
