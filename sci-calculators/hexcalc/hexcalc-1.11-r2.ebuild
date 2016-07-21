# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A simple hex calculator for X"
HOMEPAGE="ftp://ftp.x.org/R5contrib/"
SRC_URI="ftp://ftp.x.org/R5contrib/${PN}.tar.Z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="x11-libs/libXaw"
DEPEND="${RDEPEND}
	x11-misc/imake
	app-text/rman"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-*
}

src_compile() {
	xmkmf || die
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CCLINK="$(tc-getCC)" \
		LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	newman ${PN}.{man,1}
}
