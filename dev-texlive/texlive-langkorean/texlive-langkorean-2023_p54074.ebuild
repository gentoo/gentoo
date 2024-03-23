# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langkorean.r54074
	baekmuk.r56915
	cjk-ko.r67252
	kotex-oblivoir.r69662
	kotex-plain.r63689
	kotex-utf.r63690
	kotex-utils.r38727
	nanumtype1.r29558
	pmhanguljamo.r66361
	uhc.r16791
	unfonts-core.r56291
	unfonts-extra.r56291
"
TEXLIVE_MODULE_DOC_CONTENTS="
	baekmuk.doc.r56915
	cjk-ko.doc.r67252
	kotex-oblivoir.doc.r69662
	kotex-plain.doc.r63689
	kotex-utf.doc.r63690
	kotex-utils.doc.r38727
	lshort-korean.doc.r58468
	nanumtype1.doc.r29558
	pmhanguljamo.doc.r66361
	uhc.doc.r16791
	unfonts-core.doc.r56291
	unfonts-extra.doc.r56291
"

inherit texlive-module

DESCRIPTION="TeXLive Korean"

LICENSE="FDL-1.1 GPL-1 GPL-2 LPPL-1.3 LPPL-1.3c OFL TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-langcjk-2023
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/kotex-utils/jamo-normalize.pl
	texmf-dist/scripts/kotex-utils/komkindex.pl
	texmf-dist/scripts/kotex-utils/ttf2kotexfont.pl
"
