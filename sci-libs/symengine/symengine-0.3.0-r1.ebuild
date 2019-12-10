# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Fast symbolic manipulation library, written in C++"
HOMEPAGE="https://github.com/sympy/symengine"
SRC_URI="https://github.com/sympy/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/0.3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="arb benchmarks boost debug doc flint llvm mpc mpfr openmp test tcmalloc threads"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/gmp:=
	sys-libs/binutils-libs:=
	arb? ( sci-mathematics/arb:= )
	boost? ( dev-libs/boost:= )
	mpc? ( dev-libs/mpc:= )
	tcmalloc? ( dev-util/google-perftools )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
"

pkg_pretend() {
	use openmp && [[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

src_prepare() {
	cmake-utils_src_prepare
	sed -e "s|DESTINATION doc| DESTINATION share/doc/${PF}/html|" \
		-e "s|/lib|/$(get_libdir)|g" \
		-e "s|lib/|$(get_libdir)/|g" \
		-e "/DESTINATION/s|lib|$(get_libdir)|g" \
		-i CMakeLists.txt symengine/CMakeLists.txt \
		symengine/utilities/teuchos/CMakeLists.txt || die
}

src_configure() {
	# not in portage yet: piranha, ecm
	local int_class
	if use arb || use flint; then
		int_class=flint
	elif use mpfr; then
		int_class=gmpxx
	elif use boost; then
		int_class=boostmp
	else
		int_class=gmp
	fi
	local mycmakeargs=(
		-DARB_INCLUDE_DIR="${EPREFIX}/usr/include"
		-DINTEGER_CLASS="${int_class}"
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_BENCHMARKS="$(usex benchmarks)"
		-DBUILD_DOXYGEN="$(usex doc)"
		-DBUILD_TESTS="$(usex test)"
		-DWITH_ARB="$(usex arb)"
		-DWITH_BFD="$(usex debug)"
		-DWITH_SYMENGINE_ASSERT="$(usex debug)"
		-DWITH_SYMENGINE_THREAD_SAFE="$(usex threads)"
		-DWITH_FLINT="$(usex flint)"
		-DWITH_OPENMP="$(usex openmp)"
		-DWITH_MPFR="$(usex mpfr)"
		-DWITH_MPC="$(usex mpc)"
		-DWITH_LLVM="$(usex llvm)"
		-DWITH_PTHREAD="$(usex threads)"
		-DWITH_TCMALLOC="$(usex tcmalloc)"
	)
	test-flag-CXX -std=c++11 && append-cxxflags -std=c++11
	CMAKE_BUILD_TYPE=Release cmake-utils_src_configure
}
