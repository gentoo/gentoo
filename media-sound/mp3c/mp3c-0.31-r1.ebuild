# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

IUSE="mp3 vorbis"

DESCRIPTION="console based mp3 ripper, with cddb support"
HOMEPAGE="http://wspse.de/WSPse/Linux-MP3c.php3"
SRC_URI="ftp://ftp.wspse.de/pub/linux/wspse/${P}.tar.bz2"

RDEPEND="mp3? ( media-sound/lame
	>=media-sound/mp3info-0.8.4-r1 )
	virtual/cdrtools
	vorbis? ( media-sound/vorbis-tools )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"

LANGS="de es it pl pt"

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X}"
done

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-buffer.patch"
}

src_compile() {
	econf $(use_enable vorbis oggdefaults) || die "econf failed !"
	emake || die "emake failed!"
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS *README BUGS CDDB_HOWTO ChangeLog FAQ NEWS OTHERS TODO
}
