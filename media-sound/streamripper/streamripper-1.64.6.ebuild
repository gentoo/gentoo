# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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

DOCS=( CHANGES parse_rules.txt README THANKS )

src_configure() {
	econf \
		--without-included-libmad \
		--without-included-argv \
		$(use_with vorbis ogg)
}
