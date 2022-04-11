# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
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
	>=dev-python/pybtex-0.24[${PYTHON_USEDEP}]
	dev-python/pybtex-docutils[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/numpydoc[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	# this is needed to keep the tests working while
	# dev-python/namespace-sphinxcontrib is still installed
	cat > "${BUILD_DIR}/install$(python_get_sitedir)/sphinxcontrib/__init__.py" <<-EOF || die
		__path__ = __import__('pkgutil').extend_path(__path__, __name__)
	EOF
	epytest
	rm "${BUILD_DIR}/install$(python_get_sitedir)/sphinxcontrib/__init__.py" || die
}
