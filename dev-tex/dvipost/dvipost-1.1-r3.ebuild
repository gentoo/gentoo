# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package eutils toolchain-funcs

DESCRIPTION="post processor for dvi files"
HOMEPAGE="http://efeu.cybertec.at/index_en.html"
SRC_URI="http://efeu.cybertec.at/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86 ~x64-macos ~x86-macos"
IUSE=""

src_prepare() {
	tc-export CC
	eapply "${FILESDIR}"/${PV}-ldflags.patch
	default
}

src_compile() {
	emake
}

src_install() {
	dobin dvipost
	dosym dvipost /usr/bin/pptex
	dosym dvipost /usr/bin/pplatex

	insinto ${TEXMF}/tex/latex/misc/
	insopts -m0644
	doins dvipost.sty

	dodoc dvipost.doc CHANGELOG NOTES README dvipost.html
	newman "${S}"/dvipost.man dvipost.1
}
