# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A hard-disk benchmarking tool"
HOMEPAGE="http://www.lysator.liu.se/~pen/piozone/"
SRC_URI="ftp://ftp.lysator.liu.se/pub/unix/piozone/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PF}-gentoo.diff
}

src_compile() {
	append-flags -D_LARGEFILE64_SOURCE
	emake CC=$(tc-getCC) || die
}

src_install() {
	dosbin piozone
}
