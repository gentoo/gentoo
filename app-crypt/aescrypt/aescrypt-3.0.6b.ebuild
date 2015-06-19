# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/aescrypt/aescrypt-3.0.6b.ebuild,v 1.1 2013/02/01 23:37:09 alonbl Exp $

EAPI=4

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Advanced file encryption using AES"
HOMEPAGE="http://www.aescrypt.com/"
SRC_URI="https://www.aescrypt.com/download/v3/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-build.patch"
	epatch "${FILESDIR}/${P}-iconv.patch"
}

src_compile() {
	if use static; then
		append-cflags "-DDISABLE_ICONV"
		append-ldflags "-static"
	fi
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}
