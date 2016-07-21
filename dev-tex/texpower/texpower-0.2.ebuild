# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package

IUSE="doc"
MY_P="${P/./-}"

DESCRIPTION="A bundle of style and class files for creating dynamic online presentations"
SRC_URI="mirror://sourceforge/texpower/${MY_P}.tar.gz"
HOMEPAGE="http://texpower.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

S="${WORKDIR}/${MY_P}"

src_compile() {

	latex-package_src_compile

	cd tpslifonts
	latex-package_src_compile
	cp tpslifonts.sty ../ || die
	cd ../

	if use doc
	then
		for file in FAQ-display.tex FAQ-printout.tex fulldemo.tex
		do
			einfo "Making documentation: ${file}"
			VARTEXFONTS=${T}/fonts texi2pdf -q -c \
				--language=latex ${file} &> /dev/null
		done
	fi
}

src_install() {

	latex-package_src_doinstall styles pdf

	insinto /usr/share/texmf/tex/latex/${PN}/contrib
	doins contrib/config.landscapeplus contrib/tpmultiinc.tar || die

	dodoc 00readme.txt 01install.txt || die
	newdoc tpslifonts/00readme.txt 00readme-tpslifonts.txt || die
	newdoc contrib/00readme.txt 00readme-contrib.txt
}
