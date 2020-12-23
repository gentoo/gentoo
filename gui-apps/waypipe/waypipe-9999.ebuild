# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit meson python-any-r1

DESCRIPTION="transparent network proxy for Wayland compositors"
HOMEPAGE="https://gitlab.freedesktop.org/mstoeckl/waypipe"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mstoeckl/waypipe"
else
	SRC_URI="https://gitlab.freedesktop.org/mstoeckl/waypipe/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-v${PV}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

CPU_FLAGS_X86=( "avx2" "avx512f" "sse3" )
IUSE="dmabuf ffmpeg lz4 man neon systemtap test vaapi zstd ${CPU_FLAGS_X86[@]/#/cpu_flags_x86_}"
REQUIRED_USE="vaapi? ( ffmpeg )"
RESTRICT="!test? ( test )"

DEPEND="
	dmabuf? (
		media-libs/mesa[gbm,vaapi?,wayland]
		x11-libs/libdrm
	)
	lz4? ( app-arch/lz4 )
	systemtap? ( dev-util/systemtap )
	vaapi? ( x11-libs/libva[drm,wayland] )
	ffmpeg? (
		media-video/ffmpeg[x264,vaapi?]
	)
	zstd? ( app-arch/zstd )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	man? ( app-text/scdoc )
	test? ( dev-libs/weston[wayland-compositor,screen-sharing] )
"

PATCHES=(
	"${FILESDIR}"/waypipe-0.7.2-werror.patch
	"${FILESDIR}"/waypipe-0.7.2-no-simd.patch
)

src_configure() {
	local mymesonargs=(
		$(meson_use systemtap with_systemtap)
		$(meson_use neon with_neon_opts)
		$(meson_feature dmabuf with_dmabuf)
		$(meson_feature ffmpeg with_video)
		$(meson_feature lz4 with_lz4)
		$(meson_feature man man-pages)
		$(meson_feature vaapi with_vaapi)
		$(meson_feature zstd with_zstd)
	)
	local fl
	for fl in "${CPU_FLAGS_X86[@]}"; do
		mymesonargs+=( $(meson_use cpu_flags_x86_$fl with_$fl ) )
	done
	meson_src_configure
}
