# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

IUSE=""
DESCRIPTION="LSI MegaRAID control utility"
HOMEPAGE="http://sourceforge.net/projects/megactl/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
	epatch "${FILESDIR}"/${P}-Makefile.patch
	epatch "${FILESDIR}"/${P}-gcc-fixes.patch
	epatch "${FILESDIR}"/${P}-tracefix.patch
}

src_compile() {
	cd src
	use x86 && MY_MAKEOPTS="ARCH=-m32"
	use amd64 && MY_MAKEOPTS="ARCH=-m64"
	emake ${MY_MAKEOPTS} || die "make failed"
}

src_install() {
	cd src
	dosbin megactl megasasctl megarpt megasasrpt
	# it's not quite fixed yet
	[ -x megatrace ] && dosbin megatrace
	dodoc ../README
}
