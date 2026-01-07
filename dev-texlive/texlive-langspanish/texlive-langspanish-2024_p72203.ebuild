# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-langspanish.r72203
	babel-catalan.r30259
	babel-galician.r30270
	babel-spanish.r59367
	hyphen-catalan.r58609
	hyphen-galician.r58652
	hyphen-spanish.r58652
	quran-es.r72203
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
	quran-es.doc.r72203
	texlive-es.doc.r70417
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

LICENSE="CC-BY-4.0 LPPL-1.3 LPPL-1.3c MIT TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 ~riscv x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2024
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
