# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_5} )
inherit distutils-r1

DESCRIPTION="Tool to refactor valid 3.x syntax into valid 2.x syntax"
HOMEPAGE="https://pypi.org/project/3to2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	# the standard test runner fails to properly return failure
	"${PYTHON}" -m unittest discover || die "Tests fail with ${EPYTHON}"
}
