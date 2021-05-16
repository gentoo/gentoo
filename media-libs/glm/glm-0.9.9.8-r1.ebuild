# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="OpenGL Mathematics"
HOMEPAGE="http://glm.g-truc.net/"
SRC_URI="https://github.com/g-truc/glm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( HappyBunny MIT )"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 sparc x86"
IUSE="test cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_avx cpu_flags_x86_avx2"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.9.6-simd.patch
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${PN}-0.9.9.8-big-endian-tests.patch
)

src_configure() {
	# Header-only library
	if use test; then
		local mycmakeargs=(
			-DGLM_TEST_ENABLE=ON
			-DGLM_TEST_ENABLE_SIMD_SSE2="$(usex cpu_flags_x86_sse2 ON OFF)"
			-DGLM_TEST_ENABLE_SIMD_SSE3="$(usex cpu_flags_x86_sse3 ON OFF)"
			-DGLM_TEST_ENABLE_SIMD_AVX="$(usex cpu_flags_x86_avx ON OFF)"
			-DGLM_TEST_ENABLE_SIMD_AVX2="$(usex cpu_flags_x86_avx2 ON OFF)"
		)
		cmake_src_configure
	fi

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
	doheader -r glm
	insinto /usr/share/pkgconfig
	doins "${BUILD_DIR}/glm.pc"
	insinto /usr/share
	doins -r cmake
	dodoc readme.md manual.md
}
