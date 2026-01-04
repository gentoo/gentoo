# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-formatsextra.r72250
	aleph.r70015
	antomega.r21933
	eplain.r71409
	hitex.r71363
	jadetex.r71409
	lambda.r45756
	lollipop.r69742
	mltex.r71363
	mxedruli.r71991
	omega.r33046
	omegaware.r70015
	otibet.r45777
	passivetex.r69742
	psizzl.r69742
	startex.r69742
	texsis.r69742
	xmltex.r71362
"
TEXLIVE_MODULE_DOC_CONTENTS="
	aleph.doc.r70015
	antomega.doc.r21933
	eplain.doc.r71409
	hitex.doc.r71363
	jadetex.doc.r71409
	lollipop.doc.r69742
	mltex.doc.r71363
	mxedruli.doc.r71991
	omega.doc.r33046
	omegaware.doc.r70015
	otibet.doc.r45777
	psizzl.doc.r69742
	startex.doc.r69742
	texsis.doc.r69742
	xmltex.doc.r71362
"
TEXLIVE_MODULE_SRC_CONTENTS="
	antomega.source.r21933
	eplain.source.r71409
	jadetex.source.r71409
	otibet.source.r45777
	psizzl.source.r69742
	startex.source.r69742
"

inherit texlive-module

DESCRIPTION="TeXLive Additional formats"

LICENSE="GPL-1+ GPL-2+ GPL-3 LPPL-1.3c MIT TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 ~riscv x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2024
	>=dev-texlive/texlive-latex-2024
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-texlive/texlive-latexrecommended-2024
	>=dev-texlive/texlive-plaingeneric-2024
"
