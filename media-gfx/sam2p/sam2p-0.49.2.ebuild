# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sam2p/sam2p-0.49.2.ebuild,v 1.2 2014/11/08 18:31:08 vapier Exp $

EAPI=4
inherit autotools eutils toolchain-funcs

DESCRIPTION="Utility to convert raster images to EPS, PDF and many others"
HOMEPAGE="http://code.google.com/p/sam2p/"
SRC_URI="http://sam2p.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="examples gif"

RDEPEND=""
DEPEND="dev-lang/perl"

RESTRICT="test"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.45-fbsd.patch \
		"${FILESDIR}"/${PN}-0.49.1-build.patch \
		"${FILESDIR}"/${PN}-0.49-glibc-2.20.patch
	eautoreconf
	tc-export CXX
}

src_configure() {
	econf --enable-lzw $(use_enable gif)
}

src_install() {
	dobin sam2p
	dodoc README

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
