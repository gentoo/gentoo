# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/qkc/qkc-1.00.ebuild,v 1.14 2012/07/14 05:56:39 hattya Exp $

EAPI="4"

inherit toolchain-funcs

MY_P="${PN}c${PV/./}"

DESCRIPTION="Quick KANJI code Converter"
HOMEPAGE="http://hp.vector.co.jp/authors/VA000501/"
SRC_URI="http://hp.vector.co.jp/authors/VA000501/${MY_P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="app-arch/unzip"
S="${WORKDIR}"

src_prepare() {
	sed -i "/^LFLAGS/s:$: \${LDFLAGS}:" Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin qkc
	dodoc qkc.doc
	doman -i18n=ja qkc.1
}
