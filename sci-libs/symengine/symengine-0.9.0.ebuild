# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=13
inherit cmake llvm toolchain-funcs

DESCRIPTION="Fast symbolic manipulation library, written in C++"
HOMEPAGE="https://github.com/symengine/symengine"
SRC_URI="https://github.com/symengine/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"
# BUILD_FOR_DISTRIBUTION enables threads by default so do it here
IUSE="arb benchmarks boost debug doc ecm +flint llvm +mpc +mpfr openmp test tcmalloc +threads"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/gmp:=
	sys-libs/binutils-libs:=
	arb? ( sci-mathematics/arb:= )
	boost? ( dev-libs/boost:= )
	ecm? ( sci-mathematics/gmp-ecm )
	flint? ( sci-mathematics/flint:= )
	mpc? ( dev-libs/mpc:= )
	llvm? ( <sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):= )
	tcmalloc? ( dev-util/google-perftools )"
DEPEND="${RDEPEND}
	dev-libs/cereal"
BDEPEND="doc? ( app-doc/doxygen[dot] )"

PATCHES=(
	"${FILESDIR}/${PN}-0.7.0-cmake-build-type.patch"
)

pkg_pretend() {
	use openmp && [[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	use openmp && [[ ${MERGE_TYPE} != binary ]] && tc-check-openmp

	use llvm && llvm_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed -e "s|DESTINATION doc| DESTINATION share/doc/${PF}/html|" \
		-e "s|/lib|/$(get_libdir)|g" \
		-e "s|lib/|$(get_libdir)/|g" \
		-e "/DESTINATION/s|lib|$(get_libdir)|g" \
		-i CMakeLists.txt symengine/CMakeLists.txt \
		symengine/utilities/teuchos/CMakeLists.txt || die
}

src_configure() {
	# not in portage yet: piranha
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

	einfo "Building with integer class: ${int_class}"

	local mycmakeargs=(
		-DINTEGER_CLASS=${int_class}
		-DBUILD_BENCHMARKS=$(usex benchmarks)
		-DBUILD_DOXYGEN=$(usex doc)
		-DBUILD_TESTS=$(usex test)
		-DWITH_ARB=$(usex arb)
		-DWITH_BFD=$(usex debug)
		-DWITH_SYMENGINE_ASSERT=$(usex debug)
		-DWITH_SYMENGINE_THREAD_SAFE=$(usex threads)
		-DWITH_FLINT=$(usex flint)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_MPFR=$(usex mpfr)
		-DWITH_MPC=$(usex mpc)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_PTHREAD=$(usex threads)
		-DWITH_TCMALLOC=$(usex tcmalloc)
		-DWITH_ECM=$(usex ecm)
		-DWITH_SYSTEM_CEREAL=ON
	)

	use arb && mycmakeargs+=( -DARB_INCLUDE_DIR="${ESYSROOT}"/usr/include )

	cmake_src_configure
}
