# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"

inherit gnome2 eutils

MY_P=${P/terminatorx/terminatorX}
DESCRIPTION='realtime audio synthesizer that allows you to "scratch" on digitally sampled audio data'
HOMEPAGE="http://www.terminatorx.org/"
SRC_URI="http://www.terminatorx.org/dist/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa debug mad vorbis sox"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	mad? ( media-sound/madplay )
	vorbis? ( media-libs/libvorbis )
	sox? ( media-sound/sox
		media-sound/mpg123 )
	>=x11-libs/gtk+-2.2:2
	>=dev-libs/glib-2.2:2
	x11-libs/libXi
	x11-libs/libXxf86dga
	dev-libs/libxml2
	media-libs/audiofile
	media-libs/ladspa-sdk
	media-libs/ladspa-cmt
	app-text/scrollkeeper
	media-libs/liblrdf
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
	x11-proto/inputproto
	x11-proto/xf86dgaproto
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Patch from debian to compile with recent zlib
	epatch "${FILESDIR}"/${PN}-3.84-new-zlib.patch
	epatch "${FILESDIR}"/${PN}-3.84-includes.patch
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable alsa) \
		$(use_enable debug) \
		$(use_enable mad) \
		$(use_enable vorbis) \
		$(use_enable sox)
}

src_install() {
	gnome2_src_install
	newicon gnome-support/terminatorX-app.png terminatorX.png
	make_desktop_entry terminatorX terminatorX terminatorX AudioVideo
}
