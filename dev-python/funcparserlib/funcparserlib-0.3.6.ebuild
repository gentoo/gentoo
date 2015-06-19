# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/funcparserlib/funcparserlib-0.3.6.ebuild,v 1.7 2015/04/08 08:05:15 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

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
