# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Python bindings for Enlightenment Foundation Libraries"
HOMEPAGE="https://phab.enlightenment.org/w/projects/python_bindings_for_efl/"
SRC_URI="https://download.enlightenment.org/rel/bindings/python/${P}.tar.xz"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND="
	=dev-libs/efl-1.18*
	dev-python/dbus-python[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)
	test? ( =dev-libs/efl-1.18*[X] )
"

# Broken beyond repair. Fixed upstream for 1.20.
RESTRICT="test"

python_compile_all() {
	if use doc ; then
		# Point sphinx to right location with built sources
		sed -i 's|"../build/"+d|"'"${BUILD_DIR}"'/lib"|g' doc/conf.py || die

		esetup.py build_doc --build-dir "${S}"/build/doc/
	fi

	distutils-r1_python_compile
}

python_test() {
	cd "${S}"/tests || die
	# violates sandbox
	rm -f ecore/test_09_file_download.py || die
	sed -i 's:verbosity=1:verbosity=3:' 00_run_all_tests.py || die
	${EPYTHON} 00_run_all_tests.py --verbose || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use doc ; then
		local HTML_DOCS=( build/doc/html/. )
	fi

	distutils-r1_python_install_all
}
