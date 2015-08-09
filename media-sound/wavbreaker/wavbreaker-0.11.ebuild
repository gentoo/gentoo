# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

DESCRIPTION="wavbreaker/wavmerge GTK+ utility to break or merge WAV files"
HOMEPAGE="http://wavbreaker.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa nls oss pulseaudio"

RDEPEND="dev-libs/libxml2
	>=x11-libs/gtk+-2:2
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog CONTRIBUTORS NEWS README* TODO"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.10-pkgconfig.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable alsa) \
		$(use_enable pulseaudio pulse) \
		$(use_enable oss)
}
