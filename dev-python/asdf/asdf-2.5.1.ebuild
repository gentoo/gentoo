# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python library for the Advanced Scientific Data Format"
HOMEPAGE="https://asdf.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/numpy-1.8[${PYTHON_USEDEP}]
	<dev-python/jsonschema-4[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/six-1.9[${PYTHON_USEDEP}]
	>=dev-python/semantic_version-2.8.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-astropy[${PYTHON_USEDEP}]
		dev-python/gwcs[${PYTHON_USEDEP}]
		dev-python/pytest-doctestplus[${PYTHON_USEDEP}]
		dev-python/pytest-remotedata[${PYTHON_USEDEP}]
		dev-python/pytest-openfiles[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/astropy[${PYTHON_USEDEP}]
		dev-python/gwcs[${PYTHON_USEDEP}]
		dev-python/pytest-doctestplus[${PYTHON_USEDEP}]
		dev-python/pytest-remotedata[${PYTHON_USEDEP}]
		dev-python/pytest-openfiles[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# use system astropy-helpers instead of bundled one
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		python_setup
		PYTHONPATH="${BUILD_DIR}"/lib \
				  esetup.py build_sphinx --no-intersphinx
	fi
}

python_test() {
	pytest -v
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
