# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/gputils/gputils-0.13.7.ebuild,v 1.2 2010/10/12 16:57:48 armin76 Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Collection of tools including assembler, linker and librarian for PIC microcontrollers"
HOMEPAGE="http://gputils.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-strncat.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO doc/gputils.ps
	insinto /usr/share/doc/${PF}
	doins doc/gputils.pdf || die
}
