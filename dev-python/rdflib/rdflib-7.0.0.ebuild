# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="sqlite?,threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="RDF library containing a triple store and parser/serializer"
HOMEPAGE="
	https://github.com/RDFLib/rdflib/
	https://pypi.org/project/rdflib/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="examples sqlite"

RDEPEND="
	<dev-python/isodate-1[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.6.0[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	<dev-python/pyparsing-4[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# doctests require internet
	sed -i -e '/doctest-modules/d' pyproject.toml || die

	# we disable pytest-cov
	sed -i -e 's@, no_cover: None@@' test/test_misc/test_plugins.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -m "not webtest"
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
