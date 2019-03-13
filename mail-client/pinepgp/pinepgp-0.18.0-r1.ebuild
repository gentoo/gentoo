# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

DESCRIPTION="Use GPG/PGP with Pine"
HOMEPAGE="http://hany.sk/~hany/software/pinepgp/"
SRC_URI="http://terminus.sk/~hany/_data/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

DEPEND="mail-client/alpine
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
