# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/pinepgp/pinepgp-0.18.0-r1.ebuild,v 1.11 2012/02/25 16:37:41 ago Exp $

inherit eutils

DESCRIPTION="Use GPG/PGP with Pine"
HOMEPAGE="http://www.megaloman.com/~hany/software/pinepgp/"
SRC_URI="http://www.megaloman.com/~hany/_data/pinepgp/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

DEPEND="|| ( mail-client/alpine mail-client/pine )
	app-crypt/gnupg"

src_unpack()	{
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile-sed-fix.patch
}

src_install()	{
	make DESTDIR="${D}" install || die "install problem"
	dodoc ChangeLog README
}
