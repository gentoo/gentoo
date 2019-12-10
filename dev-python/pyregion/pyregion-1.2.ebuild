# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
inherit distutils-r1 virtualx xdg-utils

DESCRIPTION="Python module to parse ds9 region file"
HOMEPAGE="http://pyregion.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="MIT"

IUSE="doc examples test"
RESTRICT="!test? ( test )"
RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
		dev-python/wcsaxes[${PYTHON_USEDEP}] )
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# use astropy-helpers from system
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	xdg_environment_reset
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		python_setup
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${BUILD_DIR}"/lib \
			esetup.py build_sphinx --no-intersphinx
	fi
}

python_test() {
	virtx esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
