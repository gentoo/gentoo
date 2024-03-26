# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langgreek.r65038
	babel-greek.r68532
	begingreek.r63255
	betababel.r15878
	cbfonts.r54080
	cbfonts-fd.r54080
	gfsbaskerville.r19440
	gfsporson.r18651
	greek-fontenc.r68877
	greek-inputenc.r66634
	greekdates.r15878
	greektex.r28327
	greektonoi.r39419
	hyphen-ancientgreek.r58652
	hyphen-greek.r58652
	ibycus-babel.r15878
	ibygrk.r15878
	kerkis.r56271
	levy.r21750
	lgreek.r21818
	lgrmath.r65038
	mkgrkindex.r26313
	talos.r61820
	teubner.r68074
	xgreek.r69652
	yannisgr.r22613
"
TEXLIVE_MODULE_DOC_CONTENTS="
	babel-greek.doc.r68532
	begingreek.doc.r63255
	betababel.doc.r15878
	cbfonts.doc.r54080
	cbfonts-fd.doc.r54080
	gfsbaskerville.doc.r19440
	gfsporson.doc.r18651
	greek-fontenc.doc.r68877
	greek-inputenc.doc.r66634
	greekdates.doc.r15878
	greektex.doc.r28327
	greektonoi.doc.r39419
	hyphen-greek.doc.r58652
	ibycus-babel.doc.r15878
	ibygrk.doc.r15878
	kerkis.doc.r56271
	levy.doc.r21750
	lgreek.doc.r21818
	lgrmath.doc.r65038
	mkgrkindex.doc.r26313
	talos.doc.r61820
	teubner.doc.r68074
	xgreek.doc.r69652
	yannisgr.doc.r22613
"
TEXLIVE_MODULE_SRC_CONTENTS="
	babel-greek.source.r68532
	begingreek.source.r63255
	cbfonts-fd.source.r54080
	greekdates.source.r15878
	ibycus-babel.source.r15878
	lgrmath.source.r65038
	teubner.source.r68074
	xgreek.source.r69652
"

inherit texlive-module

DESCRIPTION="TeXLive Greek"

LICENSE="BSD-2 GPL-1 GPL-2 LGPL-3 LPPL-1.3 LPPL-1.3c TeX-other-free public-domain"
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

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/mkgrkindex/mkgrkindex
"
