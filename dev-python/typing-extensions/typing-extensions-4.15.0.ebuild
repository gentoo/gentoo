# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_VERIFY_REPO=https://github.com/python/typing_extensions
PYTHON_COMPAT=( python3_{11..15} python3_{13..15}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Backported and Experimental Type Hints for Python 3.7+"
HOMEPAGE="
	https://pypi.org/project/typing-extensions/
	https://github.com/python/typing_extensions/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-python/flit-core-3.11[${PYTHON_USEDEP}]
	test? (
		dev-python/test[${PYTHON_USEDEP}]
	)
"

# TODO: switch back to unittests once we don't need deselects
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/python/typing_extensions/pull/683
	"${FILESDIR}/${P}-py314-test.patch"
)

python_test() {
	local EPYTEST_DESELECT=()
	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				src/test_typing_extensions.py::NamedTupleTests::test_same_as_typing_NamedTuple
			)
			;;
		python3.15*)
			EPYTEST_DESELECT+=(
				src/test_typing_extensions.py::AllTests::test_alias_names_still_exist
				src/test_typing_extensions.py::AllTests::test_all_names_in___all__
				src/test_typing_extensions.py::AllTests::test_typing_extensions_includes_standard
				src/test_typing_extensions.py::GetTypeHintTests::test_annotation_and_optional_default
				src/test_typing_extensions.py::NoExtraItemsTests::test_constructor
				src/test_typing_extensions.py::NoExtraItemsTests::test_repr
				src/test_typing_extensions.py::TestSentinels::test_sentinel_deprecated
				src/test_typing_extensions.py::TestSentinels::test_sentinel_deprecated_explicit_repr
				src/test_typing_extensions.py::TypeAliasTypeTests::test_cannot_set_attributes
				src/test_typing_extensions.py::TypeVarTupleTests::test_repr
				src/test_typing_extensions.py::UnpackTests::test_repr
			)
			;;
	esac

	cd src || die
	epytest
}
