# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langitalian.r55129
	antanilipsum.r55250
	babel-italian.r69298
	codicefiscaleitaliano.r29803
	fixltxhyph.r25832
	frontespizio.r24054
	hyphen-italian.r58652
	itnumpar.r15878
	layaureo.r19087
	verifica.r56625
"
TEXLIVE_MODULE_DOC_CONTENTS="
	amsldoc-it.doc.r45662
	amsmath-it.doc.r22930
	amsthdoc-it.doc.r45662
	antanilipsum.doc.r55250
	babel-italian.doc.r69298
	codicefiscaleitaliano.doc.r29803
	fancyhdr-it.doc.r21912
	fixltxhyph.doc.r25832
	frontespizio.doc.r24054
	itnumpar.doc.r15878
	l2tabu-italian.doc.r25218
	latex4wp-it.doc.r36000
	layaureo.doc.r19087
	lshort-italian.doc.r57038
	psfrag-italian.doc.r15878
	texlive-it.doc.r58653
	verifica.doc.r56625
"
TEXLIVE_MODULE_SRC_CONTENTS="
	antanilipsum.source.r55250
	babel-italian.source.r69298
	codicefiscaleitaliano.source.r29803
	fixltxhyph.source.r25832
	frontespizio.source.r24054
	itnumpar.source.r15878
	layaureo.source.r19087
	verifica.source.r56625
"

inherit texlive-module

DESCRIPTION="TeXLive Italian"

LICENSE="FDL-1.1 GPL-1 LGPL-2 LPPL-1.3 LPPL-1.3c TeX-other-free"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2023
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
