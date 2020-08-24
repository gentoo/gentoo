# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Python to GNU Octave bridge"
HOMEPAGE="
	https://github.com/blink1073/oct2py
	https://blink1073.github.io/oct2py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	>=dev-python/numpy-1.12[${PYTHON_USEDEP}]
	>=dev-python/octave_kernel-0.31.0[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.17[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs \
	dev-python/numpydoc dev-python/sphinx-bootstrap-theme dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${PN}-5.2.0-mask-pkg-load-test.patch )

python_test() {
	cd "${BUILD_DIR}"/lib || die
	pytest -vv || die "Tests fail with ${EPYTHON}"

	# remove cache which breaks python_install()
	rm -r .pytest_cache || die
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
