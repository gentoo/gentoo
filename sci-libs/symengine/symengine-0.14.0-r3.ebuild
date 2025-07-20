# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {18..20} )
LLVM_OPTIONAL=1

inherit cmake llvm-r2 toolchain-funcs

DESCRIPTION="Fast symbolic manipulation library, written in C++"
HOMEPAGE="https://github.com/symengine/symengine/"
SRC_URI="
	https://github.com/symengine/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="
	boost debug ecm +flint llvm +mpc +mpfr openmp primesieve tcmalloc
	test
"
REQUIRED_USE="
	boost? ( !flint !mpc !mpfr )
	llvm? ( ${LLVM_REQUIRED_USE} )
	mpc? ( mpfr )
"
RESTRICT="!test? ( test )"

RDEPEND="
	boost? ( dev-libs/boost:= )
	!boost? ( dev-libs/gmp:= )
	debug? ( sys-libs/binutils-libs:= )
	ecm? ( sci-mathematics/gmp-ecm:= )
	flint? ( sci-mathematics/flint:= )
	mpc? ( dev-libs/mpc:= )
	mpfr? ( dev-libs/mpfr:= )
	llvm? ( $(llvm_gen_dep 'llvm-core/llvm:${LLVM_SLOT}=') )
	primesieve? ( sci-mathematics/primesieve:= )
	tcmalloc? ( dev-util/google-perftools )
"
DEPEND="
	${RDEPEND}
	dev-libs/cereal
"

PATCHES=(
	# bug 957803, in git master
	"${FILESDIR}/${P}-cmake4.patch"
	# https://github.com/symengine/symengine/pull/2103
	# https://github.com/symengine/symengine/pull/2119
	"${FILESDIR}/${P}-llvm.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local int_class

	if use flint; then
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
		-DINSTALL_CMAKE_DIR="${EPREFIX}/usr/$(get_libdir)/cmake/symengine"
		-DINTEGER_CLASS=${int_class}
		# not installed
		-DBUILD_BENCHMARKS=OFF
		# broken with out-of-tree builds
		-DBUILD_DOXYGEN=OFF
		-DBUILD_TESTS=$(usex test)
		# -DWITH_ARB provided by flint >= 2
		-DWITH_BFD=$(usex debug)
		-DWITH_ECM=$(usex ecm)
		-DWITH_FLINT=$(usex flint)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_MPC=$(usex mpc)
		-DWITH_MPFR=$(usex mpfr)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_PRIMESIEVE=$(usex primesieve)
		-DWITH_PTHREAD=ON
		-DWITH_SYMENGINE_ASSERT=$(usex debug)
		-DWITH_SYMENGINE_THREAD_SAFE=ON
		-DWITH_SYSTEM_CEREAL=ON
		# TODO: package it
		# -DWITH_SYSTEM_FASTFLOAT=ON
		-DWITH_TCMALLOC=$(usex tcmalloc)
	)
	if use llvm; then
		mycmakeargs+=(
			-DLLVM_ROOT="$(get_llvm_prefix -d)"
		)
	fi

	cmake_src_configure
}
