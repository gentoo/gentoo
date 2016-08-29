# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Mixer library for MATE Desktop"
LICENSE="LGPL-2 GPL-2"
SLOT="0"

IUSE="+alsa oss pulseaudio"

RDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	>=dev-libs/glib-2.36:2
	sys-devel/gettext:*
	alsa? ( >=media-libs/alsa-lib-1.0.5 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.23:0[alsa?,glib] )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0:*
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		--disable-null \
		$(use_enable alsa) \
		$(use_enable oss) \
		$(use_enable pulseaudio)
}
