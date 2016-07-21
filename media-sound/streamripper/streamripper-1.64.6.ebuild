# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="Extracts and records individual MP3 file tracks from shoutcast streams"
HOMEPAGE="http://streamripper.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="vorbis"

RDEPEND="media-libs/libmad
	media-libs/faad2
	>=dev-libs/glib-2.16
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		--disable-dependency-tracking \
		--without-included-libmad \
		--without-included-argv \
		$(use_with vorbis ogg)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc CHANGES parse_rules.txt README THANKS
}
