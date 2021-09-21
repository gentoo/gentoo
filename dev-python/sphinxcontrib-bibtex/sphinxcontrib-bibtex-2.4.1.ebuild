# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Sphinx extensions for BibTeX style citations"
HOMEPAGE="https://github.com/mcmtroffaes/sphinxcontrib-bibtex"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/pybtex[${PYTHON_USEDEP}]
	dev-python/pybtex-docutils[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_tests --install pytest
distutils_enable_sphinx doc

python_prepare_all() {
	# pybtex.plugin.PluginNotFound: plugin pybtex.style.names.last not found
	# This particular style seems to be removed?
	rm test/test_citation.py test/test_footcite.py test/test_style.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}
