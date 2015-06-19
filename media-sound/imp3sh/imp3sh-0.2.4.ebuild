# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/imp3sh/imp3sh-0.2.4.ebuild,v 1.6 2012/11/08 03:15:42 vapier Exp $

inherit toolchain-funcs

DESCRIPTION="flexible playlist manipulation shell and song player/streamer"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""

RDEPEND="sys-libs/ncurses
	media-libs/libvorbis
	media-libs/libogg
	media-libs/libao"
DEPEND="${RDEPEND}"

src_compile() {
	econf
	emake CCLD=$(tc-getCXX) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README* CHANGES web/README.imp3web web/imp3web.php EXAMPLE.imp3sh EXTERNAL.players
	# Some docs are liner notes in the actual .c files. UHG.
	dodoc piped-io/imp3sh*.c
}
