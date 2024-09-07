# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-formatsextra.r62226
	aleph.r66203
	antomega.r21933
	edmac.r61719
	eplain.r64721
	hitex.r66924
	jadetex.r69742
	lambda.r45756
	lollipop.r69742
	mltex.r62145
	mxedruli.r30021
	omega.r33046
	omegaware.r66186
	otibet.r45777
	passivetex.r69742
	psizzl.r69742
	startex.r69742
	texsis.r69742
	xmltex.r69742
"
TEXLIVE_MODULE_DOC_CONTENTS="
	aleph.doc.r66203
	antomega.doc.r21933
	edmac.doc.r61719
	eplain.doc.r64721
	hitex.doc.r66924
	jadetex.doc.r69742
	lollipop.doc.r69742
	mltex.doc.r62145
	mxedruli.doc.r30021
	omega.doc.r33046
	omegaware.doc.r66186
	otibet.doc.r45777
	psizzl.doc.r69742
	startex.doc.r69742
	texsis.doc.r69742
	xmltex.doc.r69742
"
TEXLIVE_MODULE_SRC_CONTENTS="
	antomega.source.r21933
	edmac.source.r61719
	eplain.source.r64721
	jadetex.source.r69742
	otibet.source.r45777
	psizzl.source.r69742
	startex.source.r69742
"

inherit texlive-module

DESCRIPTION="TeXLive Additional formats"

LICENSE="GPL-1+ GPL-2 GPL-2+ GPL-3 LPPL-1.3 LPPL-1.3c MIT OFL-1.1 TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2023
	>=dev-texlive/texlive-latex-2023
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-texlive/texlive-latexrecommended-2023
	>=dev-texlive/texlive-plaingeneric-2023
"
