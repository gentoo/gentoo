# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo flag-o-matic

DESCRIPTION="A portable fork of the high-performance regular expression matching library"
HOMEPAGE="
	https://www.vectorcamp.gr/vectorscan/
	https://github.com/VectorCamp/vectorscan
"
SRC_URI="
	https://github.com/VectorCamp/vectorscan/archive/refs/tags/${PN}/${PV}.tar.gz
		-> ${P}.tar.gz
"

S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="amd64 x86"
IUSE="cpu_flags_x86_avx2 cpu_flags_x86_sse4_2"

DEPEND="
	dev-libs/boost:=
"
RDEPEND="
	${DEPEND}
	!dev-libs/hyperscan
"
BDEPEND="
	dev-util/ragel
	virtual/pkgconfig
"

REQUIRED_USE="
	x86? ( cpu_flags_x86_sse4_2 )
	amd64? ( cpu_flags_x86_sse4_2 )
"

src_prepare() {
	local sedargs=(
		# Respect user -m flags (march/mtune)
		-e '/set(ARCH_CX*_FLAG/d'
		# Respect user -O flags
		-e '/set(OPT_CX*_FLAG/d'
	)
	sed -i "${sedargs[@]}" CMakeLists.txt cmake/cflags-x86.cmake || die
	cmake_src_prepare
}

src_configure() {
	use cpu_flags_x86_avx2 && append-flags -mavx2
	use cpu_flags_x86_sse4_2 && append-flags -msse4.2

	local mycmakeargs=(
		-DBUILD_BENCHMARKS=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_SHARED_LIBS=ON

		-DBUILD_AVX2=$(usex cpu_flags_x86_avx2)

		-DUSE_CPU_NATIVE=OFF
	)
	cmake_src_configure
}

src_test() {
	# The unit target cannot be used currently due to a bug in it,
	# see https://github.com/VectorCamp/vectorscan/issues/202
	#cmake_build unit
	edo "${BUILD_DIR}/bin/unit-hyperscan"
}
