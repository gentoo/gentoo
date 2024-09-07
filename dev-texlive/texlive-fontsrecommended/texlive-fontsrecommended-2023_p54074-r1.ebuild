# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-fontsrecommended.r54074
	avantgar.r61983
	bookman.r61719
	charter.r15878
	cm-super.r15878
	cmextra.r57866
	courier.r61719
	euro.r22191
	euro-ce.r25714
	eurosym.r17265
	fpl.r54512
	helvetic.r61719
	lm.r67718
	lm-math.r67718
	manfnt-font.r45777
	marvosym.r29349
	mathpazo.r52663
	mflogo-font.r54512
	ncntrsbk.r61719
	palatino.r61719
	pxfonts.r15878
	rsfs.r15878
	symbol.r61719
	tex-gyre.r68624
	tex-gyre-math.r41264
	times.r61719
	tipa.r29349
	txfonts.r15878
	utopia.r15878
	wasy.r53533
	wasy-type1.r53534
	wasysym.r54080
	zapfchan.r61719
	zapfding.r61719
"
TEXLIVE_MODULE_DOC_CONTENTS="
	charter.doc.r15878
	cm-super.doc.r15878
	euro.doc.r22191
	euro-ce.doc.r25714
	eurosym.doc.r17265
	fpl.doc.r54512
	lm.doc.r67718
	lm-math.doc.r67718
	marvosym.doc.r29349
	mathpazo.doc.r52663
	mflogo-font.doc.r54512
	pxfonts.doc.r15878
	rsfs.doc.r15878
	tex-gyre.doc.r68624
	tex-gyre-math.doc.r41264
	tipa.doc.r29349
	txfonts.doc.r15878
	utopia.doc.r15878
	wasy.doc.r53533
	wasy-type1.doc.r53534
	wasysym.doc.r54080
"
TEXLIVE_MODULE_SRC_CONTENTS="
	euro.source.r22191
	fpl.source.r54512
	marvosym.source.r29349
	mathpazo.source.r52663
	tex-gyre.source.r68624
	tex-gyre-math.source.r41264
	wasysym.source.r54080
"

inherit texlive-module

DESCRIPTION="TeXLive Recommended fonts"

LICENSE="BSD GPL-1+ GPL-2 LPPL-1.3 LPPL-1.3c OFL-1.1 TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2023
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
