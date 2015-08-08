# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit toolchain-funcs latex-package

MY_P="HLaTeX-${PV}"
DESCRIPTION="HLaTeX is a LaTeX package to use Hangul with LaTeX"
HOMEPAGE="http://project.ktug.or.kr/hlatex/"
UHCFONTS="uhc-myoungjo-1.0.tar.gz
	uhc-gothic-1.0.tar.gz
	uhc-taza-1.0.tar.gz
	uhc-graphic-1.0.tar.gz
	uhc-gungseo-1.0.tar.gz
	uhc-shinmun-1.0.tar.gz
	uhc-pilgi-1.0.tar.gz
	uhc-pen-1.0.tar.gz
	uhc-bom-1.0.tar.gz
	uhc-yetgul-1.0.tar.gz
	uhc-jamo-1.0.tar.gz
	uhc-vada-1.0.tar.gz
	uhc-pilgia-1.0.tar.gz
	uhc-dinaru-1.0.tar.gz"

SRC_URI="ftp://ftp.ktug.or.kr/pub/ktug/hlatex/${MY_P}.tar.gz
	ftp://ftp.ktug.or.kr/pub/ktug/hlatex/fonts/uhc-fonts-1.0.tar.gz
	${UHCFONTS//uhc-/ftp://ftp.ktug.or.kr/pub/ktug/hlatex/fonts/uhc-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S="${WORKDIR}/HLaTeX"

src_unpack() {
	unpack ${MY_P}.tar.gz
	unpack uhc-fonts-1.0.tar.gz
	cd "${S}"/contrib
	cat >Makefile <<-EOF
CC=$(tc-getCC)
all: hmakeindex hbibtex
hmakeindex: hmakeindex.c
hbibtex: hbibtex.c
EOF
}

src_compile() {
	cd "${S}"/contrib
	emake || die
}

src_install() {
	cd "${S}"/latex
		insinto ${TEXMF}/tex/latex/hlatex
		doins *

	cd "${S}"/lambda
		insinto ${TEXMF}/tex/lambda/hlatex
		doins u8hangul.tex uhc-test.tex uhc*.fd

		insinto ${TEXMF}/omega/otp/hlatex
		doins hlatex.otp

		insinto ${TEXMF}/omega/ocp/hlatex
		doins hlatex.ocp

	cd "${S}"/contrib
		insinto ${TEXMF}/tex/latex/hlatex
		doins hbname-k.tex khyper.sty showhkeys.sty showhtags.sty
		doins hangulfn.sty hfn-k.tex

		insinto ${TEXMF}/tex/lambda/hlatex
		doins hbname-u.tex hfn-u.tex

		insinto ${TEXMF}/bibtex/bst/hlatex
		doins halpha.bst

		insinto ${TEXMF}/makeindex
		doins hind.ist hglo.ist

		dobin hmakeindex hbibtex

	cd "${S}"
		dodoc ChangeLog.ko NEWS* README.en

	cd "${WORKDIR}"/uhc-fonts-1.0
		insinto ${TEXMF}/fonts/map/hlatex
		doins uhc-base.map uhc-extra.map

	cd "${ED}"/${TEXMF}/fonts
	for X in ${UHCFONTS}
	do
		unpack ${X}
	done
}

pkg_postinst() {
	updmap-sys --enable Map=uhc-base.map
	updmap-sys --enable Map=uhc-extra.map
	texhash
}

pkg_postrm() {
	if [ ! -e "${EPREFIX}"${TEXMF}/fonts/map/hlatex/uhc-base.map ] ; then
		updmap-sys --disable Map=uhc-base.map
	fi

	if [ ! -e "${EPREFIX}"${TEXMF}/fonts/map/hlatex/uhc-extra.map ] ; then
		updmap-sys --disable Map=uhc-extra.map
	fi

	texhash
}
