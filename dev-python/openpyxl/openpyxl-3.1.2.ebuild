# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="Pure python reader and writer of Excel OpenXML files"
HOMEPAGE="
	https://openpyxl.readthedocs.io/en/stable/
	https://foss.heptapod.net/openpyxl/openpyxl/
"
SRC_URI="
	https://foss.heptapod.net/openpyxl/openpyxl/-/archive/${PV}/${P}.tar.bz2
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	dev-python/et-xmlfile[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},tiff,jpeg]
	)
"

distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

PATCHES=(
	# https://foss.heptapod.net/openpyxl/openpyxl/-/commit/517ce7d21194da275f8083fa2fd7de6977dc7e95
	"${FILESDIR}/${P}-pytest-8.patch"
)

python_test() {
	local EPYTEST_DESELECT=()

	if has_version ">=dev-python/numpy-2[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			# https://foss.heptapod.net/openpyxl/openpyxl/-/issues/2187
			openpyxl/compat/tests/test_compat.py::test_numpy_tostring
		)
	fi

	case ${EPYTHON} in
		python3.12)
			EPYTEST_DESELECT+=(
				# deprecation warnings
				openpyxl/reader/tests/test_workbook.py::TestWorkbookParser::test_broken_sheet_ref
				openpyxl/reader/tests/test_workbook.py::TestWorkbookParser::test_defined_names_print_area
				openpyxl/reader/tests/test_workbook.py::TestWorkbookParser::test_name_invalid_index
				openpyxl/styles/tests/test_stylesheet.py::test_no_styles
			)
			;;
	esac

	epytest
}
