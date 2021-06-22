# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Converting Jupyter Notebooks"
HOMEPAGE="https://nbconvert.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	>=dev-python/entrypoints-0.2.2[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	dev-python/jupyterlab_pygments[${PYTHON_USEDEP}]
	>=dev-python/mistune-0.7.4[${PYTHON_USEDEP}]
	dev-python/nbclient[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/pandocfilters-1.4.1[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
	dev-python/testpath[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pebble[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
		>=dev-python/jupyter_client-4.2[${PYTHON_USEDEP}]
		media-gfx/inkscape
	)
"

distutils_enable_tests pytest

src_test() {
	mkdir -p "${HOME}/.local" || die
	cp -r share "${HOME}/.local/" || die
	distutils-r1_src_test
}

python_test() {
	local deselect=(
		# Missing pyppeteer for now
		# TODO: Doesn't skip?
		--deselect exporters/tests/test_webpdf.py
		# Needs pyppeteer too
		--deselect 'tests/test_nbconvertapp.py::TestNbConvertApp::test_webpdf_with_chromium'
	)

	distutils_install_for_testing bdist_egg
	cd "${TEST_DIR}"/lib || die
	pytest -vv "${deselect[@]}" --pyargs nbconvert || die "Tests failed with ${EPYTHON}"
}

pkg_postinst() {
	if ! has_version app-text/pandoc ; then
		einfo "Pandoc is required for converting to formats other than Python,"
		einfo "HTML, and Markdown. If you need this functionality, install"
		einfo "app-text/pandoc."
	fi
}
