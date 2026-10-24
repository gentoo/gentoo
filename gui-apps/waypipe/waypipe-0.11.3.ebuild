# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..14} )
RUST_MIN_VER="1.77.0"

inherit cargo meson python-any-r1

DESCRIPTION="Transparent network proxy for Wayland compositors"
HOMEPAGE="https://gitlab.freedesktop.org/mstoeckl/waypipe"

SRC_URI="
	https://gitlab.freedesktop.org/mstoeckl/waypipe/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
	https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz
"

S="${WORKDIR}/${PN}-v${PV}"
LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_FLAGS_IGNORED="usr/bin/waypipe"

WAYPIPE_FLAG_MAP_X86=(
	avx2:avx2
	avx512f:avx512f
	sse3:sse3
)
WAYPIPE_FLAG_MAP_ARM=(
	neon:neon_opts
)
WAYPIPE_FLAG_MAP=(
	"${WAYPIPE_FLAG_MAP_X86[@]/#/cpu_flags_x86_}"
	"${WAYPIPE_FLAG_MAP_ARM[@]/#/cpu_flags_arm_}"
)

IUSE="dmabuf ffmpeg gbm lz4 systemtap test vaapi zstd man legacy ${WAYPIPE_FLAG_MAP[*]%:*}"
REQUIRED_USE="vaapi? ( ffmpeg legacy ) ffmpeg? ( dmabuf )"
RESTRICT="!test? ( test )"

DEPEND="
	dmabuf? (
		media-libs/mesa[gbm(+),vaapi?,wayland]
		media-libs/vulkan-loader
	)
	lz4? ( app-arch/lz4:= )
	systemtap? ( dev-debug/systemtap )
	ffmpeg? ( media-video/ffmpeg:=[x264,vaapi?] )
	vaapi? ( media-libs/libva[drm(+),wayland] )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/wayland
	man? ( app-text/scdoc )
	lz4? ( dev-util/bindgen )
	dmabuf? ( dev-util/bindgen )
	ffmpeg? (
		dev-util/bindgen
		media-libs/shaderc
	)
	virtual/pkgconfig
	test? (
		dev-libs/weston[examples,headless,pipewire,wayland-compositor]
	)
"

pkg_setup() {
	rust_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		"$(meson_feature man man-pages)"
		"$(meson_use legacy build_c)"
		-Dbuild_rs=true
		"$(meson_feature ffmpeg with_video)"
		"$(meson_feature dmabuf with_dmabuf)"
		"$(meson_feature lz4 with_lz4)"
		"$(meson_feature zstd with_zstd)"
		"$(meson_feature gbm with_gbm)"
		"$(meson_use systemtap with_systemtap)"
		"$(meson_feature vaapi with_vaapi)"
		-Dwith_secctx=enabled
	)

	local fl
	for fl in "${WAYPIPE_FLAG_MAP[@]}"; do
		emesonargs+=( "$(meson_use "${fl%:*}" "with_${fl#*:}")" )
	done

	meson_src_configure
}

src_compile() {
	cargo_env
	meson_src_compile
}

src_test() {
	cargo_env
	meson_src_test
}
