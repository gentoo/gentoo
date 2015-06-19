# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cdctl/cdctl-0.15.ebuild,v 1.21 2009/09/23 15:59:29 patrick Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Utility to control your cd/dvd drive"
HOMEPAGE="http://cdctl.sourceforge.net/"
SRC_URI="mirror://sourceforge/cdctl/${P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="x86 ppc amd64 ppc64"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-Makefile.in.patch
	epatch "${FILESDIR}"/${P}-cdc_ioctls.patch
}

src_compile() {
	econf
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		|| die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc NEWS NUTSANDBOLTS PUBLICKEY README
}
