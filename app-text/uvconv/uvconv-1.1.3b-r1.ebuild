# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="A small utility that converts among Vietnamese charsets"
HOMEPAGE="http://unikey.org/"
SRC_URI="mirror://sourceforge/unikey/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake CXX="$(tc-getCXX)" OPTFLAGS="${CFLAGS}" -C uvconvert
}

src_install() {
	dobin uvconvert/${PN}
	doman uvconv.1
	dodoc readme.txt AUTHORS CREDITS changes.txt
}
