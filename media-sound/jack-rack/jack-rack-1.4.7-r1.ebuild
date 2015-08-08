# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils flag-o-matic toolchain-funcs

DESCRIPTION="JACK Rack is an effects rack for the JACK low latency audio API"
HOMEPAGE="http://jack-rack.sourceforge.net/"
SRC_URI="mirror://sourceforge/jack-rack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa gnome lash nls xml"

RDEPEND="x11-libs/gtk+:2
	>=media-libs/ladspa-sdk-1.12
	media-sound/jack-audio-connection-kit
	alsa? ( media-libs/alsa-lib )
	lash? ( >=media-sound/lash-0.5 )
	gnome? ( >=gnome-base/libgnomeui-2 )
	nls? ( virtual/libintl )
	xml? ( dev-libs/libxml2
		media-libs/liblrdf )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS BUGS ChangeLog NEWS README THANKS TODO WISHLIST )

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.4.5-asneeded.patch \
		"${FILESDIR}"/${PN}-1.4.6-noalsa.patch \
		"${FILESDIR}"/${PN}-1.4.7-disable_deprecated.patch

	eautoreconf
}

src_configure() {
	# Use lrdf.pc to get -I/usr/include/raptor2 (lrdf.h -> raptor.h)
	use xml && append-cppflags $($(tc-getPKG_CONFIG) --cflags lrdf)

	econf \
		$(use_enable alsa aseq) \
		$(use_enable gnome) \
		$(use_enable lash) \
		$(use_enable nls) \
		$(use_enable xml) \
		$(use_enable xml lrdf)
}
