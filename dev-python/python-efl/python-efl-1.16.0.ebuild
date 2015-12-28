# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

MY_P=${P/_/-}

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="bindings/python"
	EGIT_URI_APPEND="${PN}"
	EGIT_REPO_URI="git://git.enlightenment.org/${EGIT_SUB_PROJECT}/${EGIT_URI_APPEND}.git"
	inherit git-2
else
	SRC_URI="https://download.enlightenment.org/rel/bindings/python/${MY_P}.tar.xz"
fi

inherit distutils-r1

DESCRIPTION="Python bindings for Enlightenment Fundation Libraries"
HOMEPAGE="http://www.enlightenment.org"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=">=dev-libs/efl-${PV}
	>=media-libs/elementary-${PV}
	>dev-python/dbus-python-0.83[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/cython-0.17[${PYTHON_USEDEP}]
	doc? (
		media-gfx/graphviz[python]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	doc? ( >dev-python/sphinx-1.0[${PYTHON_USEDEP}] )"

python_compile_all() {
	if use doc ; then
		# Point sphinx to right location with builded sources
		sed -i 's|"../build/"+d|"'"${BUILD_DIR}"'/lib"|g' doc/conf.py
		esetup.py build_doc --build-dir "${S}"/build/doc/
	fi
}

python_test() {
	cd "${S}"/tests
	rm -f ecore/test_09_file_download.py # violates sandbox
	sed -i 's:verbosity=1:verbosity=3:' 00_run_all_tests.py || die
	${PYTHON} 00_run_all_tests.py --verbose || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	use doc && DOCS=( "${S}"/build/doc/html )
	use examples && EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
