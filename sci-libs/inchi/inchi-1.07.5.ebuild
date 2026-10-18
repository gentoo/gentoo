# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit cmake flag-o-matic python-any-r1

DESCRIPTION="Program and library for generating standard and non-standard InChI and InChIKeys"
HOMEPAGE="https://www.iupac.org/inchi/"
SRC_URI="https://github.com/IUPAC-InChI/InChI/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/InChI-${PV}"

LICENSE="IUPAC-InChi"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"
BDEPEND="
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.07.5-flags.patch
	"${FILESDIR}"/${PN}-1.07.5-unbundle_gtest.patch
)

python_check_deps() {
	python_has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	if use test; then
		sed -e '/INCHI_LIB_PATH = (/,/)/s|"[^"]*"|"'"${BUILD_DIR}"'/INCHI-1-SRC/INCHI_API/libinchi/src/lib/libinchi.so"|' \
			-i INCHI-1-TEST/tests/test_library/test_multithreading.py || die
	else
		cmake_comment_add_subdirectory INCHI-1-TEST/tests/test_unit
	fi
}

src_configure() {
		# gtest-1.17 requires at least C++17
		use test && append-cxxflags -std=gnu++17
		cmake_src_configure
}

src_test() {
	BUILD_DIR="${BUILD_DIR}/INCHI-1-TEST/tests/test_unit/" cmake_src_test

	local -x PYTHONPATH="${S}/INCHI-1-TEST/src"
	EPYTEST_IGNORE=(
		INCHI-1-TEST/tests/test_meta/test_performance.py # timeout
		INCHI-1-TEST/tests/test_meta/test_permutation.py # missing rdkit
		INCHI-1-TEST/tests/test_meta/test_drivers.py # needs pydantic
	)
	epytest . INCHI-1-TEST/tests/test_executable --exe-path="${BUILD_DIR}"/INCHI-1-SRC/INCHI_EXE/inchi-1/src/bin/inchi-1
	"${EPYTHON}" INCHI-1-TEST/tests/test_library/test_multithreading.py 1>/dev/null
	# this test is very verbose
	if [[ $? -eq 0 ]]; then
		einfo "test_library/test_multithreading.py PASSED"
	else
		die "test_library/test_multithreading.py FAILED"
	fi
}

src_install() {
	# no INSTALL in cmake files
	dodoc INCHI-1-SRC/readme.txt INCHI-1-DOC/{readme.txt,*.pdf}
	dobin "${BUILD_DIR}"/INCHI-1-SRC/INCHI_EXE/inchi-1/src/bin/inchi-1
	dolib.so "${BUILD_DIR}"/INCHI-1-SRC/INCHI_API/libinchi/src/lib/libinchi.so
	dosym libinchi.so /usr/$(get_libdir)/libinchi.so.${PV}
	dosym libinchi.so /usr/$(get_libdir)/libinchi.so.$(ver_cut 1)
	doheader "${S}/INCHI-1-SRC/INCHI_BASE/src/"{inchi_api,ixa}.h
}
