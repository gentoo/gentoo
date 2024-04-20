# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langczechslovak.r54074
	babel-czech.r30261
	babel-slovak.r30292
	cnbwp.r32550
	cs.r41553
	csbulletin.r65250
	cslatex.r67494
	csplain.r67934
	hyphen-czech.r58609
	hyphen-slovak.r58609
"
TEXLIVE_MODULE_DOC_CONTENTS="
	babel-czech.doc.r30261
	babel-slovak.doc.r30292
	cnbwp.doc.r32550
	csbulletin.doc.r65250
	cstex.doc.r64149
	lshort-czech.doc.r55643
	lshort-slovak.doc.r15878
	texlive-cz.doc.r62854
"
TEXLIVE_MODULE_SRC_CONTENTS="
	babel-czech.source.r30261
	babel-slovak.source.r30292
	cslatex.source.r67494
"

inherit texlive-module

DESCRIPTION="TeXLive Czech/Slovak"

LICENSE="GPL-1 LPPL-1.3 LPPL-1.3c MIT TeX-other-free"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2023
	>=dev-texlive/texlive-latex-2023
"
RDEPEND="
	${COMMON_DEPEND}
	>=app-text/texlive-core-2023[xetex]
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-texlive/texlive-luatex-2023
"
