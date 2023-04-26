# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx extension to automatically generate an examples gallery"
HOMEPAGE="
	https://github.com/sphinx-gallery/sphinx-gallery/
	https://sphinx-gallery.github.io/
	https://pypi.org/project/sphinx-gallery/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/joblib[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov-report= --cov=sphinx_gallery::' setup.cfg || die
	distutils-r1_src_prepare
}

EPYTEST_DESELECT=(
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
