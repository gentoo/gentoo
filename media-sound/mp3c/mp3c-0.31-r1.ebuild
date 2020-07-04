# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="console based mp3 ripper, with cddb support"
HOMEPAGE="http://wspse.de/WSPse/Linux-MP3c.php3"
SRC_URI="ftp://ftp.wspse.de/pub/linux/wspse/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="mp3 vorbis"

DEPEND="sys-libs/ncurses:0="
RDEPEND="
	${DEPEND}
	virtual/cdrtools
	mp3? (
		media-sound/lame
		media-sound/mp3info
	)
	vorbis? ( media-sound/vorbis-tools )"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-buffer.patch )

src_configure() {
	append-libs $($(tc-getPKG_CONFIG) --libs ncurses)
	econf $(use_enable vorbis oggdefaults)
}

src_install() {
	default
	dodoc BATCH.README CDDB_HOWTO OTHERS
}
