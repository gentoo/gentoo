# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

IUSE="ncurses oss"

DESCRIPTION="Program for adjusting soundcard volumes"
HOMEPAGE="http://umix.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc sparc x86"

DEPEND="ncurses? ( >=sys-libs/ncurses-5.2 )"

src_compile() {
	local myconf
	use ncurses || myconf="--disable-ncurses"
	use oss || myconf="${myconf} --disable-oss"
	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO
}
