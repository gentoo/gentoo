# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Sphinx extension to automatically generate an examples gallery"
HOMEPAGE="
	https://sphinx-gallery.github.io/
	https://github.com/sphinx-gallery/sphinx-gallery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

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
)
