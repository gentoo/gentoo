# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/fldigi/fldigi-3.21.82.ebuild,v 1.3 2014/08/29 11:47:17 nimiux Exp $

EAPI=4

DESCRIPTION="Sound card based multimode software modem for Amateur Radio use"
HOMEPAGE="http://www.w1hkj.com/Fldigi.html"
SRC_URI="http://www.w1hkj.com/downloads/fldigi/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="hamlib nls portaudio pulseaudio sndfile"

RDEPEND="x11-libs/fltk:1[threads,xft]
	media-libs/libsamplerate
	media-libs/libpng
	x11-misc/xdg-utils
	dev-perl/RPC-XML
	dev-perl/Term-ReadLine-Perl
	hamlib? ( media-libs/hamlib )
	portaudio? ( >=media-libs/portaudio-19_pre20071207 )
	pulseaudio? ( media-sound/pulseaudio )
	sndfile? ( >=media-libs/libsndfile-1.0.10 )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf $(use_with sndfile) \
		$(use_with portaudio) \
		$(use_with hamlib) \
		$(use_enable nls) \
		$(use_with pulseaudio) \
		--disable-silent-rules \
		--without-asciidoc
}
