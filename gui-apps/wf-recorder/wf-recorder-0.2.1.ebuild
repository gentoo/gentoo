# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Screen recorder for wlroots-based compositors"
HOMEPAGE="https://github.com/ammen99/wf-recorder"
SRC_URI="https://github.com/ammen99/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+man opencl"

DEPEND="dev-libs/wayland
	dev-libs/wayland-protocols
	media-sound/pulseaudio
	media-video/ffmpeg
	opencl? ( virtual/opencl )"
RDEPEND="${DEPEND}"
BDEPEND="man? ( app-text/scdoc )"

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature opencl)
	)
	meson_src_configure
}
