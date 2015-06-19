# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/megactl/megactl-0.4.1-r1.ebuild,v 1.3 2014/07/14 00:52:23 robbat2 Exp $

EAPI=2

inherit eutils

IUSE=""
DESCRIPTION="LSI MegaRAID control utility"
HOMEPAGE="http://sourceforge.net/projects/megactl/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	cd src
	use x86 && MY_MAKEOPTS="ARCH=-m32"
	use amd64 && MY_MAKEOPTS="ARCH=-m64"
	emake ${MY_MAKEOPTS} || die "make failed"
}

src_install() {
	cd src
	dosbin megactl megasasctl
	use x86 && dosbin megatrace
	use amd64 && ewarn "megatrace was not installed because it does not compile on amd64"
	dodoc megarpt megasasrpt ../README
}
