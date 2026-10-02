# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langczechslovak.r54074
	babel-czech.r30261
	babel-slovak.r30292
	cnbwp.r69910
	cs.r79618
	csbulletin.r77112
	cslatex.r79618
	csplain.r79618
	hyphen-czech.r78069
	hyphen-slovak.r78069
"
TEXLIVE_MODULE_SRC_CONTENTS="
	babel-czech.doc.r30261
	babel-slovak.doc.r30292
	cnbwp.doc.r69910
	csbulletin.doc.r77112
	cstex.doc.r64149
	lshort-czech.doc.r55643
	lshort-slovak.doc.r79461
	texlive-cz.doc.r77067
"
TEXLIVE_MODULE_DOC_CONTENTS="
	babel-czech.source.r30261
	babel-slovak.source.r30292
	cslatex.source.r79618
"

inherit texlive-module

DESCRIPTION="TeXLive Czech/Slovak"

LICENSE="GPL-1+ GPL-2+ LPPL-1.3 LPPL-1.3c TeX-other-free"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2026
	>=dev-texlive/texlive-latex-2026
"
RDEPEND="
	${COMMON_DEPEND}
	>=app-text/texlive-core-2026[xetex]
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-texlive/texlive-luatex-2026
"
