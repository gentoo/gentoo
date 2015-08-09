# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A curses media indexer and player for vi users"
HOMEPAGE="http://vitunes.org/"
SRC_URI="http://vitunes.org/files/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/taglib
	sys-libs/ncurses"
RDEPEND="${DEPEND}
	|| ( media-video/mplayer media-video/mplayer2 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch
	epatch "${FILESDIR}"/${P}-time-header.patch
}

src_compile() {
	tc-export CC
	emake -f Makefile.linux
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc DEVELOPERS.txt add_urls.sh
}
