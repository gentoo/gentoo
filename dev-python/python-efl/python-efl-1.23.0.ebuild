# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..7} )

inherit distutils-r1

DESCRIPTION="Python bindings for Enlightenment Foundation Libraries"
HOMEPAGE="https://phab.enlightenment.org/w/projects/python_bindings_for_efl/"
SRC_URI="https://download.enlightenment.org/rel/bindings/python/${P}.tar.xz"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="=dev-libs/efl-1.23*
	dev-python/dbus-python[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.28.4[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)"

src_prepare() {
	default

	# Tries to download a file under /tmp
	rm tests/ecore/test_09_file_download.py || die

	# Tries to use that file which failed to download
	rm tests/ecore/test_10_file_monitor.py || die

	# Needs an active internet connection
	rm tests/ecore/test_11_con.py || die

	# Test fails because of deleted files above
	sed -i 's/>= 13/>= 10/g' tests/ecore/test_08_exe.py || die

	# Make tests verbose
	sed -i 's:verbosity=1:verbosity=3:' tests/00_run_all_tests.py || die
}

python_compile_all() {
	if use doc ; then
		esetup.py build_doc --build-dir "${S}"/build/doc/
	fi

	distutils-r1_python_compile
}

python_test() {
	cd tests/ || die
	${EPYTHON} 00_run_all_tests.py --verbose || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( ./build/doc/html/. )
	distutils-r1_python_install_all
}
