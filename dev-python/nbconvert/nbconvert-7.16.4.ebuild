# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Converting Jupyter Notebooks"
HOMEPAGE="
	https://nbconvert.readthedocs.io/
	https://github.com/jupyter/nbconvert/
	https://pypi.org/project/nbconvert/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-4.7[${PYTHON_USEDEP}]
	dev-python/jupyterlab-pygments[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.0[${PYTHON_USEDEP}]
	<dev-python/mistune-4[${PYTHON_USEDEP}]
	>=dev-python/nbclient-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/nbformat-5.7[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pandocfilters-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.4.1[${PYTHON_USEDEP}]
	dev-python/tinycss2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		>=dev-python/ipywidgets-7.5[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		tests/test_nbconvertapp.py::TestNbConvertApp::test_convert_full_qualified_name
		tests/test_nbconvertapp.py::TestNbConvertApp::test_post_processor
		# crazy qtweb* stuff, perhaps permissions
		tests/exporters/test_qtpdf.py::TestQtPDFExporter::test_export
		tests/exporters/test_qtpng.py::TestQtPNGExporter::test_export
	)

	# virtx implies nonfatal, make it explicit to avoid confusion
	nonfatal epytest || die
}

pkg_postinst() {
	if ! has_version virtual/pandoc; then
		einfo "Pandoc is required for converting to formats other than Python,"
		einfo "HTML, and Markdown. If you need this functionality, install"
		einfo "app-text/pandoc or app-text/pandoc-bin."
	fi
}
