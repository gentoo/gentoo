# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{10..12} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

# see scripts/download_import_cldr.py
CLDR_PV=42.0
DESCRIPTION="Collection of tools for internationalizing Python applications"
HOMEPAGE="
	https://babel.pocoo.org/
	https://pypi.org/project/Babel/
	https://github.com/python-babel/babel/
"
SRC_URI+="
	https://unicode.org/Public/cldr/${CLDR_PV%.*}/cldr-common-${CLDR_PV}.zip
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

# RDEPEND in BDEPEND for import_cldr.py usage, bug #852158
BDEPEND="
	app-arch/unzip
	${RDEPEND}
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_prepare() {
	rm babel/locale-data/*.dat || die
	rm babel/global.dat || die
	distutils-r1_src_prepare
}

python_configure() {
	if [[ ! -f babel/global.dat ]]; then
		"${EPYTHON}" scripts/import_cldr.py "${WORKDIR}"/common || die
	fi
}

python_test() {
	local EPYTEST_DESELECT=()
	if [[ ${EPYTHON} == python3.12 ]]; then
		EPYTEST_DESELECT+=(
			# seems to be a corner case, might be a regression in cpython
			# https://github.com/python-babel/babel/issues/1005
			tests/messages/test_extract.py::ExtractPythonTestCase::test_utf8_message_with_utf8_bom
			tests/messages/test_extract.py::ExtractPythonTestCase::test_utf8_message_with_utf8_bom_and_magic_comment
			tests/messages/test_extract.py::ExtractPythonTestCase::test_utf8_raw_strings_match_unicode_strings
			tests/messages/test_extract.py::ExtractTestCase::test_f_strings
			tests/messages/test_extract.py::ExtractTestCase::test_f_strings_non_utf8
		)
	fi

	local -x TZ=UTC
	epytest
}
