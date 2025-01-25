# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A specialized XML reader to navigate C++ declarations"
HOMEPAGE="
	https://github.com/CastXML/pygccxml/
	https://pypi.org/project/pygccxml/
"
SRC_URI="
	https://github.com/CastXML/pygccxml/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv ~x86"

DEPEND="
	${PYTHON_DEPS}
	dev-libs/castxml
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

EPYTEST_DESELECT=(
	# fails with >=gcc-14
	# with 'unable to find actual class definition 'type''
	tests/test_cached_source_file.py
	tests/test_core.py
	tests/test_cpp_standards.py
	tests/test_decl_printer.py
	tests/test_declarations_comparison.py
	tests/test_file_cache.py
	tests/test_non_copyable_recursive.py
	tests/test_null_comparison.py
	tests/test_overrides.py
	tests/test_pattern_parser.py::test_template_split_std_vector
	tests/test_project_reader_correctness.py
	tests/test_xmlfile_reader.py

	tests/test_example.py

	# spaces inside <  >
	tests/test_variable_matcher.py::test_no_defaults
	tests/test_vector_traits.py::test_element_type
	tests/test_remove_template_defaults.py
	tests/test_find_container_traits.py
)

python_prepare_all() {
	local PATCHES=(
		# force -std=c++14 as default for tests because of errors due to
		# test files with dynamic exception specification
		"${FILESDIR}/${PN}-2.6.1-xml_generator.patch"
		"${FILESDIR}/${PN}-2.4.0-doc.patch"
	)

	distutils-r1_python_prepare_all
}
