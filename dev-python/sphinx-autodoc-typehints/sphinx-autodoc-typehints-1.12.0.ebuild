# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Type hints support for the Sphinx autodoc extension "
HOMEPAGE="
	https://github.com/agronholm/sphinx-autodoc-typehints/
	https://pypi.org/project/sphinx-autodoc-typehints/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 sparc x86"
SLOT="0"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/sphobjinv[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	)
"

# https://github.com/agronholm/sphinx-autodoc-typehints/issues/176
RDEPEND="<dev-python/sphinx-4[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	# why on earth would this have to connect to the internet
	sed -i \
		-e 's:test_parse_annotation:_&:' \
		-e 's:test_format_annotation:_&:' \
		-e 's:test_format_annotation_both_libs:_&:' \
		tests/test_sphinx_autodoc_typehints.py || die

	distutils-r1_python_prepare_all
}
