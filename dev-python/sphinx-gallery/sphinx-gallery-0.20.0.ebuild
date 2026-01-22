# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx extension to automatically generate an examples gallery"
HOMEPAGE="
	https://github.com/sphinx-gallery/sphinx-gallery/
	https://sphinx-gallery.github.io/
	https://pypi.org/project/sphinx-gallery/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 x86"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	>=dev-python/sphinx-5[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/joblib[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		sphinx_gallery/tests/test_docs_resolv.py::test_embed_code_links_get_data
		sphinx_gallery/tests/test_full.py::test_run_sphinx
		sphinx_gallery/tests/test_full.py::test_embed_links_and_styles
		# require jupyterlite_sphinx
		sphinx_gallery/tests/test_full.py
		sphinx_gallery/tests/test_full_noexec.py
		sphinx_gallery/tests/test_gen_gallery.py::test_create_jupyterlite_contents
		sphinx_gallery/tests/test_gen_gallery.py::test_create_jupyterlite_contents_non_default_contents
		sphinx_gallery/tests/test_gen_gallery.py::test_create_jupyterlite_contents_with_jupyterlite_disabled_via_config
	)

	epytest -o addopts=
}
