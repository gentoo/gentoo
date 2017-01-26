# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

MY_P=${P/terminatorx/terminatorX}
DESCRIPTION='realtime audio synthesizer that allows you to "scratch" on digitally sampled audio data'
HOMEPAGE="http://www.terminatorx.org/"
SRC_URI="http://www.terminatorx.org/dist/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X alsa debug mad pulseaudio vorbis sox"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	mad? ( media-sound/madplay )
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( media-libs/libvorbis )
	sox? ( media-sound/sox
		media-sound/mpg123 )
	x11-libs/gtk+:3
	>=dev-libs/glib-2.2:2

	X? (
		x11-libs/libXi
		x11-libs/libXxf86dga
		x11-proto/xproto
		x11-proto/inputproto
		x11-proto/xf86dgaproto )
	dev-libs/libxml2:2
	media-libs/audiofile:=
	media-libs/ladspa-sdk
	media-libs/ladspa-cmt
	media-libs/liblrdf
"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	gnome2_src_configure \
		$(use_enable alsa) \
		$(use_enable debug) \
		$(use_enable mad) \
		$(use_enable pulseaudio pulse) \
		$(use_enable vorbis) \
		$(use_enable sox) \
		$(use_enable X x11)
}
