# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Recursive descent parsing library based on functional combinators"
HOMEPAGE="https://pypi.org/project/funcparserlib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( doc/*.md )
	distutils-r1_python_install_all
}
