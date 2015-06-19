# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/cutter/cutter-1.03-r1.ebuild,v 1.5 2014/07/10 22:21:46 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="TCP/IP Connection cutting on Linux Firewalls and Routers"
HOMEPAGE="http://www.digitage.co.uk/digitage/software/linux-security/cutter"
SRC_URI="http://www.digitage.co.uk/digitage/files/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_prepare() {
	epatch "${FILESDIR}"/${P}-debian.patch
	rm -f Makefile # implicit rules are better ;x
}

src_compile() {
	emake cutter CC="$(tc-getCC)"
}

src_install() {
	dosbin cutter
	dodoc README
	doman debian/cutter.8
}
