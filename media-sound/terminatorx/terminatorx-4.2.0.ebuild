# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2

MY_P=${P/terminatorx/terminatorX}

DESCRIPTION="Realtime audio synthesizer allowing you to 'scratch' on sampled audio data"
HOMEPAGE="https://terminatorx.org/"
# this is the original location but there is an issue with their certificate so mirroring the file
#SRC_URI="https://terminatorx.org/dist/${MY_P}.tar.bz2"
SRC_URI="https://dev.gentoo.org/~fordfrog/distfiles/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Making X optional fails when disabled: https://bugs.gentoo.org/636832
IUSE="+alsa debug jack mad pulseaudio vorbis sox"

REQUIRED_USE="|| ( alsa jack pulseaudio )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:2
	media-libs/audiofile:=
	media-libs/ladspa-sdk
	media-libs/liblrdf
	media-plugins/cmt-plugins
	x11-libs/gtk+:3
	x11-libs/libXi
	x11-libs/libXxf86dga
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	mad? ( media-sound/madplay )
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( media-libs/libvorbis )
	sox? (
		media-sound/sox
		media-sound/mpg123
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-metadata-dir.patch"
)

src_configure() {
	gnome2_src_configure \
		--enable-x11 \
		$(use_enable alsa) \
		$(use_enable debug) \
		$(use_enable jack) \
		$(use_enable mad) \
		$(use_enable pulseaudio pulse) \
		$(use_enable vorbis) \
		$(use_enable sox)
}
