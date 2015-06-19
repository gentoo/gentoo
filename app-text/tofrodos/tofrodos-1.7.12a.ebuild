# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tofrodos/tofrodos-1.7.12a.ebuild,v 1.2 2014/01/20 07:57:31 heroxbd Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="text file conversion utility that converts ASCII files between the
MSDOS format and the Unix format"
HOMEPAGE="http://tofrodos.sourceforge.net/"
SRC_URI="http://tofrodos.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}/src"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.7.8-CFLAGS.patch
}

src_compile() {
	emake DEBUG=1 CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"
}

src_install() {
	dobin fromdos
	dosym fromdos /usr/bin/todos
	doman fromdos.1
}
