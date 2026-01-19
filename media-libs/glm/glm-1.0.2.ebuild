# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="OpenGL Mathematics"
HOMEPAGE="http://glm.g-truc.net/"
SRC_URI="https://github.com/g-truc/glm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( HappyBunny MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test cpu_flags_x86_sse2 cpu_flags_x86_sse3
	cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2
	cpu_flags_x86_avx cpu_flags_x86_avx2"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.9.8-big-endian-tests.patch
	"${FILESDIR}"/${P}-cmake.patch
)

DOCS=( manual.md readme.md )

src_configure() {
	# Header-only library
	local mycmakeargs=(
		-DGLM_BUILD_INSTALL=ON
		-DGLM_BUILD_LIBRARY=OFF
		-DGLM_BUILD_TESTS=$(usex test)
	)

	if use test; then
		# See https://github.com/g-truc/glm/pull/1087
		# https://bugs.gentoo.org/818235
		test-flag-CXX -fno-ipa-modref && append-cxxflags -fno-ipa-modref

		mycmakeargs+=(
			-DGLM_TEST_ENABLE=ON
			-DGLM_ENABLE_SIMD_SSE2="$(usex cpu_flags_x86_sse2 ON OFF)"
			-DGLM_ENABLE_SIMD_SSE3="$(usex cpu_flags_x86_sse3 ON OFF)"
			-DGLM_ENABLE_SIMD_SSSE3="$(usex cpu_flags_x86_ssse3 ON OFF)"
			-DGLM_ENABLE_SIMD_SSE4_1="$(usex cpu_flags_x86_sse4_1 ON OFF)"
			-DGLM_ENABLE_SIMD_SSE4_2="$(usex cpu_flags_x86_sse4_2 ON OFF)"
			-DGLM_ENABLE_SIMD_AVX="$(usex cpu_flags_x86_avx ON OFF)"
			-DGLM_ENABLE_SIMD_AVX2="$(usex cpu_flags_x86_avx2 ON OFF)"
		)
	fi

	cmake_src_configure

	sed \
		-e "s:@CMAKE_INSTALL_PREFIX@:${EPREFIX}/usr:" \
		-e "s:@GLM_VERSION@:$(ver_cut 1-3):" \
		"${FILESDIR}"/glm.pc.in \
		> "${BUILD_DIR}/glm.pc" || die
}

src_compile() {
	# Header-only library
	if use test; then
		cmake_src_compile
	fi
}

src_install() {
	cmake_src_install

	insinto /usr/share/pkgconfig
	doins "${BUILD_DIR}/glm.pc"
}
