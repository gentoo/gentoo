# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 multiprocessing pypi virtualx

DESCRIPTION="Converting Jupyter Notebooks"
HOMEPAGE="
	https://nbconvert.readthedocs.io/
	https://github.com/jupyter/nbconvert/
	https://pypi.org/project/nbconvert/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# <mistune-3 for https://github.com/jupyter/nbconvert/pull/1820 (bug #908377)
RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-core-4.7[${PYTHON_USEDEP}]
	dev-python/jupyterlab-pygments[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.0[${PYTHON_USEDEP}]
	<dev-python/mistune-3[${PYTHON_USEDEP}]
	>=dev-python/nbclient-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/nbformat-5.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pandocfilters-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.4.1[${PYTHON_USEDEP}]
	dev-python/tinycss2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-5.1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		>=dev-python/ipywidgets-7[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	mkdir -p share/templates/classic/static || die
	# tries to refetch stuff even if it's already present
	sed -e 's:css = .*:raise PermissionError("You shall not fetch!"):' \
		-i hatch_build.py || die
	distutils-r1_src_prepare
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# Missing pyppeteer for now
		# TODO: Doesn't skip?
		nbconvert/exporters/tests/test_webpdf.py
		# Needs pyppeteer too
		'nbconvert/tests/test_nbconvertapp.py::TestNbConvertApp::test_webpdf_with_chromium'
		# TODO
		nbconvert/exporters/tests/test_qtpng.py::TestQtPNGExporter::test_export
		nbconvert/tests/test_nbconvertapp.py::TestNbConvertApp::test_convert_full_qualified_name
		nbconvert/tests/test_nbconvertapp.py::TestNbConvertApp::test_post_processor
		# latex failing, might be too new pandoc
		nbconvert/tests/test_nbconvertapp.py::TestNbConvertApp::test_filename_spaces
		nbconvert/tests/test_nbconvertapp.py::TestNbConvertApp::test_pdf
		# too new pandoc but we don't have old anymore
		nbconvert/utils/tests/test_pandoc.py::TestPandoc::test_minimal_version
		nbconvert/utils/tests/test_pandoc.py::TestPandoc::test_pandoc_available
	)

	# virtx implies nonfatal, make it explicit to avoid confusion
	nonfatal epytest -n "$(makeopts_jobs)" --pyargs nbconvert || die
}

pkg_postinst() {
	if ! has_version virtual/pandoc; then
		einfo "Pandoc is required for converting to formats other than Python,"
		einfo "HTML, and Markdown. If you need this functionality, install"
		einfo "app-text/pandoc or app-text/pandoc-bin."
	fi
}
