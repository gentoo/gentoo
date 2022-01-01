# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Sphinx extension to automatically generate an examples gallery"
HOMEPAGE="
	https://sphinx-gallery.github.io/
	https://github.com/sphinx-gallery/sphinx-gallery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
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

	# tests require internet
	sed -e 's:test_embed_code_links_get_data:_&:' \
		-i sphinx_gallery/tests/test_docs_resolv.py || die
	sed -e 's:test_run_sphinx:_&:' \
		-e 's:test_embed_links_and_styles:_&:' \
		-i sphinx_gallery/tests/test_full.py || die

	distutils-r1_src_prepare
}
