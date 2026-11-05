# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langgreek.r65038
	babel-greek.r78101
	begingreek.r63255
	betababel.r79618
	cbfonts.r54080
	cbfonts-fd.r54080
	gfsbaskerville.r79618
	gfsporson.r79618
	greek-fontenc.r77682
	greek-inputenc.r66634
	greekdates.r79618
	greektex.r28327
	greektonoi.r79618
	hyphen-ancientgreek.r78069
	hyphen-greek.r78069
	ibycus-babel.r79618
	ibygrk.r15878
	kerkis.r56271
	levy.r76924
	lgreek.r21818
	lgrmath.r65038
	mkgrkindex.r26313
	talos.r61820
	teubner.r68074
	xgreek.r79601
	yannisgr.r22613
"
TEXLIVE_MODULE_SRC_CONTENTS="
	babel-greek.doc.r78101
	begingreek.doc.r63255
	betababel.doc.r79618
	cbfonts.doc.r54080
	cbfonts-fd.doc.r54080
	gfsbaskerville.doc.r79618
	gfsporson.doc.r79618
	greek-fontenc.doc.r77682
	greek-inputenc.doc.r66634
	greekdates.doc.r79618
	greektex.doc.r28327
	greektonoi.doc.r79618
	hyphen-greek.doc.r78069
	ibycus-babel.doc.r79618
	ibygrk.doc.r15878
	kerkis.doc.r56271
	levy.doc.r76924
	lgreek.doc.r21818
	lgrmath.doc.r65038
	mkgrkindex.doc.r26313
	talos.doc.r61820
	teubner.doc.r68074
	xgreek.doc.r79601
	yannisgr.doc.r22613
"
TEXLIVE_MODULE_DOC_CONTENTS="
	babel-greek.source.r78101
	begingreek.source.r63255
	cbfonts-fd.source.r54080
	greekdates.source.r79618
	ibycus-babel.source.r79618
	lgrmath.source.r65038
	teubner.source.r68074
	xgreek.source.r79601
"

inherit texlive-module

DESCRIPTION="TeXLive Greek"

LICENSE="BSD-2 GPL-1+ GPL-2 LGPL-3 LPPL-1.0 LPPL-1.3 LPPL-1.3c TeX-other-free public-domain"
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

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/mkgrkindex/mkgrkindex
"
