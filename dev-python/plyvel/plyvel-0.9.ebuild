# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Python interface to LevelDB"
HOMEPAGE="https://github.com/wbolster/plyvel"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="dev-libs/leveldb"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile() {
	python_is_python3 || local -x CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake doc
}

python_test() {
	local lib="$(ls "${BUILD_DIR}/lib/${PN}/"*.so | head -n1)"
	ln -s "${lib}" "${PN}" || die
	py.test || die "tests failed with ${EPYTHON}"
	rm "${PN}/$(basename "${lib}")" || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build//html/. )
	distutils-r1_python_install_all
}
