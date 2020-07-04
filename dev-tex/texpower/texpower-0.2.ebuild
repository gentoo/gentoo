# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

MY_P="${P/./-}"

DESCRIPTION="A bundle of style and class files for creating dynamic online presentations"
HOMEPAGE="http://texpower.sourceforge.net/"
SRC_URI="mirror://sourceforge/texpower/${MY_P}.tar.gz"

KEYWORDS="amd64 ppc sparc x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

S="${WORKDIR}/${MY_P}"

src_compile() {

	latex-package_src_compile

	cd tpslifonts
	latex-package_src_compile
	cp tpslifonts.sty ../ || die "Copy failed"
	cd ../

	if use doc
	then
		for file in FAQ-display.tex FAQ-printout.tex fulldemo.tex
		do
			einfo "Making documentation: ${file}"
			VARTEXFONTS=${T}/fonts texi2pdf -q -c \
				--language=latex ${file} &> /dev/null || die "Making documentation failed"
		done
	fi
}

src_install() {

	latex-package_src_doinstall styles pdf

	insinto /usr/share/texmf/tex/latex/${PN}/contrib
	doins contrib/config.landscapeplus contrib/tpmultiinc.tar

	dodoc 00readme.txt 01install.txt
	newdoc tpslifonts/00readme.txt 00readme-tpslifonts.txt
	newdoc contrib/00readme.txt 00readme-contrib.txt
}
