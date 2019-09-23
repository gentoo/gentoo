# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
PATCHES=(
	"${FILESDIR}/${PN}-buffer.patch"
	"${FILESDIR}/${PN}-fix-linking.patch"
)

src_configure() {
	econf $(use_enable vorbis oggdefaults) || die "econf failed !"
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS *README BUGS CDDB_HOWTO ChangeLog FAQ NEWS OTHERS TODO
}
