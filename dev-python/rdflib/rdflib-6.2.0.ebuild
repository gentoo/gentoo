# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite?,threads(+)"

inherit distutils-r1 optfeature

DESCRIPTION="RDF library containing a triple store and parser/serializer"
HOMEPAGE="
	https://github.com/RDFLib/rdflib/
	https://pypi.org/project/rdflib/
"
SRC_URI="
	https://github.com/RDFLib/rdflib/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="examples sqlite"

RDEPEND="
	dev-python/isodate[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/berkeleydb[${PYTHON_USEDEP}]
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
	local EPYTEST_DESELECT=(
		# some of them fail with encoding problems (bad code most likely)
		# but too many to list them one by one
		test/test_w3c_spec/test_sparql11_w3c.py::test_entry_sparql11
		"test/test_sparql/test_result.py::test_select_result_serialize_parse[xml-TEXT_IO-utf-8]"
		"test/test_sparql/test_result.py::test_select_result_serialize_parse[xml-STR_PATH-utf-8]"
		"test/test_sparql/test_result.py::test_select_result_serialize_parse[xml-BINARY_IO-utf-8]"
		"test/test_sparql/test_result.py::test_select_result_serialize_parse[xml-None-utf-8]"
		"test/test_sparql/test_result.py::test_select_result_parse_serialized[xml-TEXT_IO-utf-8]"

		# Internet
		test/test_sparql/test_service.py
		"test/jsonld/test_onedotone.py::test_suite[https://w3c.github.io/json-ld-api/tests/toRdf-manifest#tc034-do_test_parser-https://w3c.github.io/json-ld-api/tests/-toRdf-c034-toRdf/c034-in.jsonld-toRdf/c034-out.nq-False-options66]"
		"test/jsonld/test_onedotone.py::test_suite[https://w3c.github.io/json-ld-api/tests/toRdf-manifest#te126-do_test_parser-https://w3c.github.io/json-ld-api/tests/-toRdf-e126-toRdf/e126-in.jsonld-toRdf/e126-out.nq-False-options167]"
		"test/jsonld/test_onedotone.py::test_suite[https://w3c.github.io/json-ld-api/tests/toRdf-manifest#te127-do_test_parser-https://w3c.github.io/json-ld-api/tests/-toRdf-e127-toRdf/e127-in.jsonld-toRdf/e127-out.nq-False-options168]"
		"test/jsonld/test_onedotone.py::test_suite[https://w3c.github.io/json-ld-api/tests/toRdf-manifest#tso05-do_test_parser-https://w3c.github.io/json-ld-api/tests/-toRdf-so05-toRdf/so05-in.jsonld-toRdf/so05-out.nq-False-options253]"
		"test/jsonld/test_onedotone.py::test_suite[https://w3c.github.io/json-ld-api/tests/toRdf-manifest#tso08-do_test_parser-https://w3c.github.io/json-ld-api/tests/-toRdf-so08-toRdf/so08-in.jsonld-toRdf/so08-out.nq-False-options254]"
		"test/jsonld/test_onedotone.py::test_suite[https://w3c.github.io/json-ld-api/tests/toRdf-manifest#tso09-do_test_parser-https://w3c.github.io/json-ld-api/tests/-toRdf-so09-toRdf/so09-in.jsonld-toRdf/so09-out.nq-False-options255]"
		"test/jsonld/test_onedotone.py::test_suite[https://w3c.github.io/json-ld-api/tests/toRdf-manifest#tso11-do_test_parser-https://w3c.github.io/json-ld-api/tests/-toRdf-so11-toRdf/so11-in.jsonld-toRdf/so11-out.nq-False-options256]"
		test/test_extras/test_infixowl/test_basic.py::test_infix_owl_example1
		test/test_extras/test_infixowl/test_context.py::test_context
		test/test_graph/test_graph.py::test_guess_format_for_parse
	)
	local EPYTEST_IGNORE=(
		# Uses network
		test/test_so_69984830.py
	)
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	epytest
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	optfeature "support for sys-libs/db (Berkeley DB for MySQL)" dev-python/berkeleydb
}
