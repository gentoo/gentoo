# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Configure your serial ports with it"
HOMEPAGE="http://setserial.sourceforge.net/"
SRC_URI="ftp://tsx-11.mit.edu/pub/linux/sources/sbin/${P}.tar.gz
	 ftp://ftp.sunsite.org.uk/Mirrors/tsx-11.mit.edu/pub/linux/sources/sbin/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-spelling.patch
	epatch "${FILESDIR}"/${P}-manpage-updates.patch
	epatch "${FILESDIR}"/${P}-headers.patch
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-hayes-esp.patch #309883
	epatch "${FILESDIR}"/${P}-darwin.patch #541536
}

src_compile() {
	tc-export CC
	econf || die
	emake setserial || die
}

src_install() {
	doman setserial.8
	into /
	dobin setserial || die

	insinto /etc
	doins serial.conf
	newinitd "${FILESDIR}"/serial-2.17-r4 serial

	dodoc README
	docinto txt
	dodoc Documentation/*
}
