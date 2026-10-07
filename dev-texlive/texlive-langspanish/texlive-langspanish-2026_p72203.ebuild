# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langspanish.r72203
	babel-catalan.r30259
	babel-galician.r30270
	babel-spanish.r79461
	hyphen-catalan.r78069
	hyphen-galician.r78069
	hyphen-spanish.r78069
	quran-es.r74874
"
TEXLIVE_MODULE_SRC_CONTENTS="
	antique-spanish-units.doc.r69568
	babel-catalan.doc.r30259
	babel-galician.doc.r30270
	babel-spanish.doc.r79461
	es-tex-faq.doc.r15878
	hyphen-spanish.doc.r78069
	l2tabu-spanish.doc.r15878
	latex2e-help-texinfo-spanish.doc.r75712
	latexcheat-esmx.doc.r36866
	lshort-spanish.doc.r79461
	quran-es.doc.r74874
	texlive-es.doc.r78678
"
TEXLIVE_MODULE_DOC_CONTENTS="
	babel-catalan.source.r30259
	babel-galician.source.r30270
	babel-spanish.source.r79461
	hyphen-galician.source.r78069
	hyphen-spanish.source.r78069
"

inherit texlive-module

DESCRIPTION="TeXLive Spanish"

LICENSE="CC-BY-4.0 GPL-2+ LPPL-1.3 LPPL-1.3c MIT TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2026
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
