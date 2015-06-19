# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/dcd/dcd-0.95.ebuild,v 1.16 2009/08/03 12:59:29 ssuominen Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A simple command-line based CD Player"
HOMEPAGE="http://www.technopagan.org/dcd"
SRC_URI="http://www.technopagan.org/dcd/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc ppc64 sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" CDROM="/dev/cdrom" EXTRA_CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin dcd || die "dobin failed"
	doman dcd.1
	dodoc README BUGS ChangeLog
}
