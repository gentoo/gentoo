# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic linux-info toolchain-funcs

DESCRIPTION="Collection of high-performance ray tracing kernels"
HOMEPAGE="https://github.com/embree/embree"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/embree/embree/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="3"
X86_CPU_FLAGS=( sse2:sse2 sse4_2:sse4_2 avx:avx avx2:avx2 avx512dq:avx512dq )
CPU_FLAGS=( ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_} )
IUSE="+compact-polys ispc +raymask ssp +tbb tutorial static-libs ${CPU_FLAGS[@]%:*}"
BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	ispc? ( dev-lang/ispc )
	>=media-libs/glfw-3.2.1
	tbb? ( dev-cpp/tbb )
	tutorial? (
		>=media-libs/libpng-1.6.34:0=
		>=media-libs/openimageio-1.8.7
		virtual/jpeg:0
	)
	virtual/opengl
"
DEPEND="${RDEPEND}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md readme.pdf )

pkg_setup() {
	CONFIG_CHECK="~TRANSPARENT_HUGEPAGE"
	WARNING_TRANSPARENT_HUGEPAGE="Not enabling Transparent Hugepages (CONFIG_TRANSPARENT_HUGEPAGE) will impact rendering performance."
	linux-info_pkg_setup

	if ! ( cat /proc/cpuinfo | grep sse2 > /dev/null ) ; then
		die "You need a CPU with at least sse2 support"
	fi
}

src_prepare() {
	cmake_src_prepare

	# disable RPM package building
	sed -e 's|CPACK_RPM_PACKAGE_RELEASE 1|CPACK_RPM_PACKAGE_RELEASE 0|' \
		-i CMakeLists.txt || die
}

src_configure() {
	# NOTE: You can make embree accept custom CXXFLAGS by turning off
	# EMBREE_IGNORE_CMAKE_CXX_FLAGS. However, the linking will fail if you use
	# any "march" compile flags. This is because embree builds modules for the
	# different supported ISAs and picks the correct one at runtime.
	# "march" will pull in cpu instructions that shouldn't be in specific modules
	# and it fails to link properly.
	# https://github.com/embree/embree/issues/115

	filter-flags -march=*

	local mycmakeargs=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON
		-DEMBREE_BACKFACE_CULLING=OFF	   	# default
		-DEMBREE_COMPACT_POLYS=$(usex compact-polys)
		-DEMBREE_FILTER_FUNCTION=ON			# default
		-DEMBREE_GEOMETRY_CURVE=ON			# default
		-DEMBREE_GEOMETRY_GRID=ON			# default
		-DEMBREE_GEOMETRY_INSTANCE=ON	   	# default
		-DEMBREE_GEOMETRY_POINT=ON			# default
		-DEMBREE_GEOMETRY_QUAD=ON			# default
		-DEMBREE_GEOMETRY_SUBDIVISION=ON	# default
		-DEMBREE_GEOMETRY_TRIANGLE=ON		# default
		-DEMBREE_GEOMETRY_USER=ON			# default
		-DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
		-DEMBREE_IGNORE_INVALID_RAYS=OFF	# default
		-DEMBREE_MAX_ISA:STRING="NONE"		# Set to NONE so we can manually switch on ISAs below
		-DEMBREE_ISA_AVX=$(usex cpu_flags_x86_avx)
		-DEMBREE_ISA_AVX2=$(usex cpu_flags_x86_avx2)
		-DEMBREE_ISA_AVX512=$(usex cpu_flags_x86_avx512dq)
		-DEMBREE_ISA_SSE2=$(usex cpu_flags_x86_sse2)
		-DEMBREE_ISA_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DEMBREE_ISPC_SUPPORT=$(usex ispc)
		-DEMBREE_RAY_MASK=$(usex raymask)
		-DEMBREE_RAY_PACKETS=ON				# default
		-DEMBREE_STACK_PROTECTOR=$(usex ssp)
		-DEMBREE_STATIC_LIB=$(usex static-libs)
		-DEMBREE_STAT_COUNTERS=OFF
		-DEMBREE_TASKING_SYSTEM:STRING=$(usex tbb "TBB" "INTERNAL")
		-DEMBREE_TUTORIALS=$(usex tutorial) )

	# Disable asserts
	append-flags  -DNDEBUG

	if use tutorial; then
		mycmakeargs+=(
			-DEMBREE_ISPC_ADDRESSING:STRING="64"
			-DEMBREE_TUTORIALS_LIBJPEG=ON
			-DEMBREE_TUTORIALS_LIBPNG=ON
			-DEMBREE_TUTORIALS_OPENIMAGEIO=ON )
	fi

	cmake_src_configure
}
