# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langspanish.r67307
	babel-catalan.r30259
	babel-galician.r30270
	babel-spanish.r59367
	hyphen-catalan.r58609
	hyphen-galician.r58652
	hyphen-spanish.r58652
"
TEXLIVE_MODULE_DOC_CONTENTS="
	antique-spanish-units.doc.r69568
	babel-catalan.doc.r30259
	babel-galician.doc.r30270
	babel-spanish.doc.r59367
	es-tex-faq.doc.r15878
	hyphen-spanish.doc.r58652
	l2tabu-spanish.doc.r15878
	latex2e-help-texinfo-spanish.doc.r65614
	latexcheat-esmx.doc.r36866
	lshort-spanish.doc.r35050
	texlive-es.doc.r66059
"
TEXLIVE_MODULE_SRC_CONTENTS="
	babel-catalan.source.r30259
	babel-galician.source.r30270
	babel-spanish.source.r59367
	hyphen-galician.source.r58652
	hyphen-spanish.source.r58652
"

inherit texlive-module

DESCRIPTION="TeXLive Spanish"

LICENSE="CC-BY-4.0 LPPL-1.3 MIT TeX-other-free public-domain"
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
