# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/ringtonetools/ringtonetools-2.26.ebuild,v 1.6 2008/11/02 18:47:26 mrness Exp $

inherit eutils toolchain-funcs

DESCRIPTION="program for creating ringtones and logos for mobile phones"
HOMEPAGE="http://ringtonetools.mikekohn.net/"
SRC_URI="http://downloads.mikekohn.net/ringtonetools/${P}.tar.gz"

LICENSE="ringtonetools"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${P}-no-strip.patch"
}

src_compile() {
	emake -j1 FLAGS="${CFLAGS}" LIBS="${LDFLAGS}" CC="$(tc-getCC)" || die "make failed"
}

src_install() {
	dobin ringtonetools || die "program not found"
	dodoc docs/*
	docinto samples
	dodoc samples/*
}
