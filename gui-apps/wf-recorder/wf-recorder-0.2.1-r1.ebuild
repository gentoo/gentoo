# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Screen recorder for wlroots-based compositors"
HOMEPAGE="https://github.com/ammen99/wf-recorder"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ammen99/wf-recorder.git"
else
	SRC_URI="https://github.com/ammen99/wf-recorder/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+man opencl"

DEPEND="
	dev-libs/wayland
	media-sound/pulseaudio
	media-video/ffmpeg[opencl?,pulseaudio,x264]
	opencl? ( virtual/opencl )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-libs/wayland-protocols
	man? ( >=app-text/scdoc-1.9.3 )
"

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature opencl)
	)
	meson_src_configure
}
