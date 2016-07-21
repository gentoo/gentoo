# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit latex-package eutils toolchain-funcs

DESCRIPTION="post processor for dvi files"
HOMEPAGE="http://efeu.cybertec.at/index_en.html"
SRC_URI="http://efeu.cybertec.at/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x64-macos ~x86-macos"
IUSE=""

src_prepare() {
	tc-export CC
	epatch "${FILESDIR}"/${PV}-ldflags.patch
}

src_compile() {
	emake || die
}

src_install() {
	dobin dvipost || die
	dosym dvipost /usr/bin/pptex || die
	dosym dvipost /usr/bin/pplatex || die

	insinto ${TEXMF}/tex/latex/misc/
	insopts -m0644
	doins dvipost.sty || die

	dodoc dvipost.doc CHANGELOG NOTES README || die
	dohtml dvipost.html || die
	newman "${S}"/dvipost.man dvipost.1 || die
}
