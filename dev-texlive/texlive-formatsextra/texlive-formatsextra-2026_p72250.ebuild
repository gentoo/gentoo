# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-formatsextra.r72250
	aleph.r77830
	antomega.r21933
	eplain.r71409
	hitex.r77830
	jadetex.r79618
	lambda.r45756
	lollipop.r69742
	mltex.r71363
	mxedruli.r79618
	omega.r33046
	omegaware.r77830
	otibet.r45777
	passivetex.r69742
	psizzl.r69742
	startex.r69742
	texsis.r79618
	xmltex.r76924
"
TEXLIVE_MODULE_SRC_CONTENTS="
	aleph.doc.r77830
	antomega.doc.r21933
	eplain.doc.r71409
	hitex.doc.r77830
	jadetex.doc.r79618
	lollipop.doc.r69742
	mltex.doc.r71363
	mxedruli.doc.r79618
	omega.doc.r33046
	omegaware.doc.r77830
	otibet.doc.r45777
	psizzl.doc.r69742
	startex.doc.r69742
	texsis.doc.r79618
	xmltex.doc.r76924
"
TEXLIVE_MODULE_DOC_CONTENTS="
	antomega.source.r21933
	eplain.source.r71409
	jadetex.source.r79618
	otibet.source.r45777
	psizzl.source.r69742
	startex.source.r69742
"

inherit texlive-module

DESCRIPTION="TeXLive Additional formats"

LICENSE="GPL-1+ GPL-2+ GPL-3 LPPL-1.0 LPPL-1.3 LPPL-1.3c MIT TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2026
	>=dev-texlive/texlive-latex-2026
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-texlive/texlive-latexrecommended-2026
	>=dev-texlive/texlive-plaingeneric-2026
"
