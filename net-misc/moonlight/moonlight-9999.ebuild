# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/moonlight-stream/moonlight-qt.git"
	EGIT_SUBMODULES=( '*' -libs )
	inherit git-r3
else
	SRC_URI="https://github.com/moonlight-stream/moonlight-qt/releases/download/v${PV}/MoonlightSrc-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}"
fi

inherit qmake-utils xdg

DESCRIPTION="NVIDIA GameStream (and Sunshine) client"
HOMEPAGE="https://github.com/moonlight-stream/moonlight-qt"

LICENSE="GPL-3"
SLOT="0"
IUSE="cuda +drm embedded glslow +vaapi vdpau vkslow vulkan wayland X"

RDEPEND="
	dev-libs/openssl:=
	dev-qt/qtbase:6[gui,network]
	dev-qt/qtdeclarative:6[svg]
	media-libs/libglvnd
	media-libs/libsdl2[gles2,haptic,joystick,kms,sound,video]
	media-libs/opus
	media-libs/sdl2-ttf
	>=media-video/ffmpeg-6:=[cuda?,drm?,vaapi?,vdpau?,vulkan?]
	drm? ( x11-libs/libdrm )
	vaapi? ( media-libs/libva:=[wayland?,X?] )
	vdpau? (
		x11-libs/libvdpau
		media-libs/libsdl2[X]
	)
	vulkan? ( media-libs/libplacebo:= )
	wayland? ( dev-libs/wayland )
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qtbase:6
	virtual/pkgconfig
"

src_prepare() {
	default
}

src_configure() {
	local qmake_args=(
		PREFIX="${EPREFIX}/usr"
		CONFIG+="
			disable-mmal
			$(usex cuda "" disable-cuda)
			$(usex drm "" disable-libdrm)
			$(usex vaapi "" disable-libva)
			$(usex vdpau "" disable-libvdpau)
			$(usex vulkan "" disable-libplacebo)
			$(usex wayland "" disable-wayland)
			$(usex X "" disable-x11)
			$(usev embedded)
			$(usev glslow)
			$(usev vkslow)
		"
	)

	eqmake6 "${qmake_args[@]//$'\n'}"
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs
}
