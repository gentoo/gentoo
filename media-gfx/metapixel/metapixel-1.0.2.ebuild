# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="a program for generating photomosaics"
HOMEPAGE="http://www.complang.tuwien.ac.at/schani/metapixel"
SRC_URI="http://www.complang.tuwien.ac.at/schani/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/perl
	media-libs/giflib
	>=media-libs/libpng-1.4
	virtual/jpeg"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng15.patch

	sed -i -e 's:/usr/X11R6:/usr:g' Makefile || die
	sed -i -e 's:ar:$(AR):' rwimg/Makefile || die
}

src_compile() {
	emake AR="$(tc-getAR)" CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}" LDOPTS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}{,-prepare,-imagesize,-sizesort}
	doman ${PN}.1
	dodoc NEWS README
}
