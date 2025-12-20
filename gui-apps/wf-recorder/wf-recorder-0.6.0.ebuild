# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Screen recorder for wlroots-based compositors"
HOMEPAGE="https://github.com/ammen99/wf-recorder"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ammen99/wf-recorder.git"
else
	SRC_URI="https://github.com/ammen99/wf-recorder/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="pipewire pulseaudio"

DEPEND="
	dev-libs/wayland
	media-libs/mesa[opengl,wayland]
	media-video/ffmpeg:=[pulseaudio?,x264]
	x11-libs/libdrm
	pipewire? ( >=media-video/pipewire-1.0.5:= )
	pulseaudio? ( media-libs/libpulse )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature pulseaudio pulse)
		$(meson_feature pipewire)
	)
	meson_src_configure
}
