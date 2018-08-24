# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package toolchain-funcs

DESCRIPTION="A post processor for dvi files, created by latex or tex"
HOMEPAGE="http://members.aon.at/fruehstueck/dvipost/index.html"
SRC_URI="http://efeu.cybertec.at/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x86-macos"

PATCHES=( "${FILESDIR}"/${PV}-ldflags.patch )
DOCS=( CHANGELOG dvipost.doc dvipost.html NOTES README )

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin dvipost
	dosym dvipost /usr/bin/pptex
	dosym dvipost /usr/bin/pplatex

	insinto ${TEXMF}/tex/latex/misc/
	insopts -m0644
	doins dvipost.sty

	einstalldocs
	newman "${S}"/dvipost.man dvipost.1
}
