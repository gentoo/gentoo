# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit meson python-any-r1

DESCRIPTION="Transparent network proxy for Wayland compositors"
HOMEPAGE="https://gitlab.freedesktop.org/mstoeckl/waypipe"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mstoeckl/waypipe"
else
	SRC_URI="https://gitlab.freedesktop.org/mstoeckl/waypipe/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
	S="${WORKDIR}"/${PN}-v${PV}
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

WAYPIPE_FLAG_MAP_X86=( avx2:with_avx2 avx512f:with_avx512f sse3:with_sse3 )
WAYPIPE_FLAG_MAP_ARM=( neon:with_neon_opts )
WAYPIPE_FLAG_MAP=(
	"${WAYPIPE_FLAG_MAP_X86[@]/#/cpu_flags_x86_}"
	"${WAYPIPE_FLAG_MAP_ARM[@]/#/cpu_flags_arm_}"
)

IUSE="dmabuf ffmpeg lz4 systemtap test vaapi zstd ${WAYPIPE_FLAG_MAP[@]%:*}"
REQUIRED_USE="vaapi? ( ffmpeg )"
RESTRICT="!test? ( test )"

DEPEND="
	dmabuf? (
		media-libs/mesa[gbm(+),vaapi?,wayland]
		x11-libs/libdrm
	)
	lz4? ( app-arch/lz4 )
	systemtap? ( dev-debug/systemtap )
	vaapi? ( media-libs/libva[drm(+),wayland] )
	ffmpeg? (
		media-video/ffmpeg[x264,vaapi?]
	)
	zstd? ( app-arch/zstd )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	app-text/scdoc
	virtual/pkgconfig
	test? ( dev-libs/weston[examples,headless,remoting,screen-sharing,wayland-compositor] )
"

src_configure() {
	local emesonargs=(
		-Dman-pages=enabled
		$(meson_use systemtap with_systemtap)
		$(meson_feature dmabuf with_dmabuf)
		$(meson_feature ffmpeg with_video)
		$(meson_feature lz4 with_lz4)
		$(meson_feature vaapi with_vaapi)
		$(meson_feature zstd with_zstd)
	)
	local fl
	for fl in "${WAYPIPE_FLAG_MAP[@]}"; do
		emesonargs+=( $(meson_use "${fl%:*}" "${fl#*:}") )
	done
	meson_src_configure
}
