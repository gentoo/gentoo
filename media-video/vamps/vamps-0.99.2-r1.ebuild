# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vamps/vamps-0.99.2-r1.ebuild,v 1.1 2007/11/19 19:47:44 aballier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Very fast requantisizing tool for backup DVDs"
HOMEPAGE="http://vamps.sourceforge.net/"
SRC_URI="mirror://sourceforge/vamps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND=">=media-libs/libdvdread-0.9.4"

RDEPEND="${DEPEND}
	>=media-video/dvdauthor-0.6.10"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-premature-eof.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	dobin vamps/vamps play_cell/play_cell || die "install failed"
}
