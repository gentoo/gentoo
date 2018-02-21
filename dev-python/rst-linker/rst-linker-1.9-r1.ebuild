# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy{,3} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Sphinx plugin to add links and timestamps to the changelog"
HOMEPAGE="https://github.com/jaraco/rst.linker"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd"
IUSE="doc test"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/path-py[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	py.test -v --ignore=rst || die "tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# namespace used only by this package in Gentoo at the moment
	python_moduleinto rst
	python_domodule rst/__init__.py
}

python_install_all() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
