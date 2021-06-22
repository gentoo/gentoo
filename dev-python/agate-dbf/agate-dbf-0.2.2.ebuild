# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Adds read support for DBF files to agate."
HOMEPAGE="https://github.com/wireservice/agate-dbf https://pypi.org/project/agate-dbf/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +xml"
RESTRICT="!test? ( test )"

# Other packages have BDEPEND="test? ( dev-python/agate-dbf[xml] )"
AGATE_VERSION_DEP=">=dev-python/agate-1.5.0"
TEST_AGAINST_RDEPEND="xml? ( ${AGATE_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"
RDEPEND="
	${AGATE_VERSION_DEP}[${PYTHON_USEDEP}]
	>=dev-python/dbfread-2.0.5[${PYTHON_USEDEP}]

	${TEST_AGAINST_RDEPEND}
"
BDEPEND="test? ( ${AGATE_VERSION_DEP}[xml,${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

AGATE_DBF_TEST_FILES=(
	examples/test.dbf
	examples/testdbf_converted.csv
	tests/test_table.py
)
SRC_URI+=" test? ( "
for extra_file in "${AGATE_DBF_TEST_FILES[@]}"; do
	SRC_URI+=" https://raw.githubusercontent.com/wireservice/agate-dbf/${PV}/${extra_file} -> ${P}_${extra_file//\//%2F}"
done
SRC_URI+=" )"

agate-dbf_src_prepare() {
	local extra_file
	if use test; then
		for extra_file in "${AGATE_DBF_TEST_FILES[@]}"; do
			mkdir -p "${extra_file%/*}" || die
			cp "${DISTDIR}/${P}_${extra_file//\//%2F}" "${extra_file}" || die
			[[${extra_file} == *.py ]] && { true >> "${extra_file%/*}/__init__.py" || die; }
		done
	fi
}

src_prepare() {
	agate-dbf_src_prepare
	distutils-r1_src_prepare
}
