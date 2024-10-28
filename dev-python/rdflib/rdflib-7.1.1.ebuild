# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite?,threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="RDF library containing a triple store and parser/serializer"
HOMEPAGE="
	https://github.com/RDFLib/rdflib/
	https://pypi.org/project/rdflib/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="examples sqlite"

RDEPEND="
	<dev-python/isodate-1[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.7.2[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	<dev-python/pyparsing-4[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# https://src.fedoraproject.org/fork/salimma/rpms/python-rdflib/blob/d2fbf492897262350bd569f1566b97a54e092cd9/f/rdflib-py3_13-fix-pickler.diff
	"${FILESDIR}/${PN}-7.1.0-py3_13-fix-pickler.diff"
)

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# doctests require internet
	sed -i -e '/doctest-modules/d' pyproject.toml || die

	# we disable pytest-cov
	sed -i -e 's@, no_cover: None@@' test/test_misc/test_plugins.py || die

	# allow regular html5lib, html5rdf is a fork with minimal changes:
	# removing six dep (which is kinda good) and bundling webencodings
	# (which is horrible)
	find -name '*.py' -exec sed -i -e 's:html5rdf:html5lib:g' {} + || die
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
