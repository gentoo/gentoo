# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

MY_P=${P/terminatorx/terminatorX}

DESCRIPTION="Realtime audio synthesizer allowing you to 'scratch' on sampled audio data"
HOMEPAGE="http://www.terminatorx.org/"
SRC_URI="http://www.terminatorx.org/dist/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
# Making X optional fails when disabled: https://bugs.gentoo.org/636832
IUSE="alsa debug mad pulseaudio vorbis sox"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	mad? ( media-sound/madplay )
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( media-libs/libvorbis )
	sox? ( media-sound/sox
		media-sound/mpg123 )
	x11-libs/gtk+:3
	>=dev-libs/glib-2.2:2

	x11-libs/libXi
	x11-libs/libXxf86dga

	dev-libs/libxml2:2
	media-libs/audiofile:=
	media-libs/ladspa-sdk
	media-libs/liblrdf
	media-plugins/cmt-plugins
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	app-text/gnome-doc-utils
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# Fails to build with USE="X vorbis -alsa -debug -mad -pulseaudio
	# -sox", bug #604288
	"${FILESDIR}"/${P}-gtkcombotext.patch
	# 740502
	"${FILESDIR}"/${P}-desktop-QA.patch
)

src_configure() {
	gnome2_src_configure \
		--enable-x11 \
		$(use_enable alsa) \
		$(use_enable debug) \
		$(use_enable mad) \
		$(use_enable pulseaudio pulse) \
		$(use_enable vorbis) \
		$(use_enable sox)
}
