# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic linux-info toolchain-funcs

DESCRIPTION="Collection of high-performance ray tracing kernels"
HOMEPAGE="https://github.com/embree/embree"
SRC_URI="https://github.com/embree/embree/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="-* ~amd64 ~arm64"
X86_CPU_FLAGS=( sse2 sse4_2 avx avx2 avx512dq )
CPU_FLAGS=( cpu_flags_arm_neon ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_} )
IUSE="compact-polys ispc +raymask ssp +tbb test ${CPU_FLAGS[@]}"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( ${CPU_FLAGS[@]} )"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	ispc? ( dev-lang/ispc )
	tbb? ( dev-cpp/tbb:= )
"
DEPEND="${RDEPEND}"

DOCS=( CHANGELOG.md README.md readme.pdf )

PATCHES=(
	"${FILESDIR}"/embree-4.3.0-dont-install-tutorials.patch
)

pkg_setup() {
	CONFIG_CHECK="~TRANSPARENT_HUGEPAGE"
	WARNING_TRANSPARENT_HUGEPAGE="Not enabling Transparent Hugepages (CONFIG_TRANSPARENT_HUGEPAGE) will impact rendering performance."

	linux-info_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# disable RPM package building
	sed -e 's|CPACK_RPM_PACKAGE_RELEASE 1|CPACK_RPM_PACKAGE_RELEASE 0|' \
		-i CMakeLists.txt || die
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/859838
	# https://github.com/embree/embree/issues/481
	filter-lto

	# NOTE: You can make embree accept custom CXXFLAGS by turning off
	# EMBREE_IGNORE_CMAKE_CXX_FLAGS. However, the linking will fail if you use
	# any "m*" compile flags. This is because embree builds modules for the
	# different supported ISAs and picks the correct one at runtime.
	# "m*" will pull in cpu instructions that shouldn't be in specific modules
	# and it fails to link properly.
	# https://github.com/embree/embree/issues/115

	filter-flags -m*

	# https://bugs.gentoo.org/910164
	tc-is-clang && filter-lto

	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON

		# Default culling settings for Blender
		# (Cycles will not render correctly without these)
		# Some Embree tests will fail with these settings though...
		-DEMBREE_BACKFACE_CULLING=OFF
		-DEMBREE_BACKFACE_CULLING_CURVES=ON
		-DEMBREE_BACKFACE_CULLING_SPHERES=ON

		-DEMBREE_COMPACT_POLYS=$(usex compact-polys)

		# Make sure that we are using our custom compilie flags
		-DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF

		# Set to NONE so we can manually switch on ISAs below
		-DEMBREE_MAX_ISA:STRING="NONE"
		-DEMBREE_ISA_AVX=$(usex cpu_flags_x86_avx)
		-DEMBREE_ISA_AVX2=$(usex cpu_flags_x86_avx2)
		-DEMBREE_ISA_AVX512=$(usex cpu_flags_x86_avx512dq)
		# TODO look into neon 2x support
		-DEMBREE_ISA_NEON=$(usex cpu_flags_arm_neon)
		-DEMBREE_ISA_SSE2=$(usex cpu_flags_x86_sse2)
		-DEMBREE_ISA_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DEMBREE_ISPC_SUPPORT=$(usex ispc)
		-DEMBREE_RAY_MASK=$(usex raymask)

		-DEMBREE_STACK_PROTECTOR=$(usex ssp)
		-DEMBREE_STATIC_LIB=OFF
		-DEMBREE_TASKING_SYSTEM:STRING=$(usex tbb "TBB" "INTERNAL")
		# Tutorial binaries are required by the tests
		-DEMBREE_TUTORIALS=$(usex test)
		-DEMBREE_ZIP_MODE=OFF
	)

	# Disable asserts
	append-cppflags -DNDEBUG

	if use test; then
		mycmakeargs+=(
			-DBUILD_TESTING=ON
			-DEMBREE_TESTING_INSTALL_TESTS=OFF
			-DEMBREE_TESTING_INTENSITY=4
			# These tutorials are not used by the default tests
			-DEMBREE_TUTORIALS_GLFW=OFF
			-DEMBREE_TUTORIALS_INSTALL=OFF
			-DEMBREE_TUTORIALS_LIBJPEG=OFF
			-DEMBREE_TUTORIALS_LIBPNG=OFF
			-DEMBREE_TUTORIALS_OPENIMAGEIO=OFF
		)
	fi

	cmake_src_configure
}
