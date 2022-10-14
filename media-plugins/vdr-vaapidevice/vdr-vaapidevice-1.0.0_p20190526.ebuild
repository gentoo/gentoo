# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

GIT_COMMIT="d19657bae399e79df107e316ca40922d21393f80"

DESCRIPTION="VDR Plugin: A VA-API output device plugin for VDR"
HOMEPAGE="https://github.com/pesintta/vdr-plugin-vaapidevice"
SRC_URI="https://github.com/pesintta/vdr-plugin-vaapidevice/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"

LICENSE="AGPL-3"
SLOT="0"
IUSE="debug"

RDEPEND="
	media-video/vdr
	media-video/ffmpeg[vaapi,X]
	media-libs/libva[X]
	media-libs/libva-intel-driver[X]
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-keysyms
	media-libs/alsa-lib
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-vaapidevice.*
	usr/lib64/vdr/plugins/libvdr-vaapidevice.*
"
S="${WORKDIR}/vdr-plugin-vaapidevice-${GIT_COMMIT}"

src_prepare() {
	vdr-plugin-2_src_prepare

	use debug && append-cppflags -DDEBUG

	local GIT_COMMIT_SHORT=${GIT_COMMIT:0:7}
	sed -i -e "s:GIT_REV =.*:GIT_REV=-${GIT_COMMIT_SHORT}:" Makefile || die "Failed to modify Makefile"
}
