# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langportuguese.r67125
	babel-portuges.r59883
	feupphdteses.r30962
	hyphen-portuguese.r58609
	numberpt.r51640
	ordinalpt.r15878
	ptlatexcommands.r67125
"
TEXLIVE_MODULE_DOC_CONTENTS="
	babel-portuges.doc.r59883
	beamer-tut-pt.doc.r15878
	cursolatex.doc.r24139
	feupphdteses.doc.r30962
	latex-via-exemplos.doc.r68627
	latexcheat-ptbr.doc.r15878
	lshort-portuguese.doc.r55643
	numberpt.doc.r51640
	ordinalpt.doc.r15878
	ptlatexcommands.doc.r67125
	xypic-tut-pt.doc.r15878
"
TEXLIVE_MODULE_SRC_CONTENTS="
	babel-portuges.source.r59883
	numberpt.source.r51640
	ordinalpt.source.r15878
	ptlatexcommands.source.r67125
"

inherit texlive-module

DESCRIPTION="TeXLive Portuguese"

LICENSE="GPL-1 GPL-2+ LPPL-1.3 LPPL-1.3c MIT public-domain"
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
