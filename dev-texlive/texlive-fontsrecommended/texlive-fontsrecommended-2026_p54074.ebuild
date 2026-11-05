# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-fontsrecommended.r54074
	avantgar.r77161
	bookman.r77161
	charter.r15878
	cm-super.r15878
	cmextra.r57866
	courier.r77161
	euro.r79618
	euro-ce.r25714
	eurosym.r78101
	fpl.r79618
	helvetic.r77161
	lm.r77682
	lm-math.r67718
	manfnt-font.r45777
	marvosym.r79618
	mathpazo.r77682
	mflogo-font.r54512
	ncntrsbk.r77161
	palatino.r77161
	pxfonts.r77682
	rsfs.r15878
	symbol.r77161
	tex-gyre.r68624
	tex-gyre-math.r41264
	times.r77161
	tipa.r79618
	txfonts.r77682
	utopia.r77682
	wasy.r53533
	wasy-type1.r53534
	wasysym.r77682
	zapfchan.r77161
	zapfding.r77161
"
TEXLIVE_MODULE_SRC_CONTENTS="
	charter.doc.r15878
	cm-super.doc.r15878
	euro.doc.r79618
	euro-ce.doc.r25714
	eurosym.doc.r78101
	fpl.doc.r79618
	lm.doc.r77682
	lm-math.doc.r67718
	marvosym.doc.r79618
	mathpazo.doc.r77682
	mflogo-font.doc.r54512
	pxfonts.doc.r77682
	rsfs.doc.r15878
	tex-gyre.doc.r68624
	tex-gyre-math.doc.r41264
	tipa.doc.r79618
	txfonts.doc.r77682
	utopia.doc.r77682
	wasy.doc.r53533
	wasy-type1.doc.r53534
	wasysym.doc.r77682
"
TEXLIVE_MODULE_DOC_CONTENTS="
	euro.source.r79618
	fpl.source.r79618
	marvosym.source.r79618
	mathpazo.source.r77682
	tex-gyre.source.r68624
	tex-gyre-math.source.r41264
	wasysym.source.r77682
"

inherit texlive-module

DESCRIPTION="TeXLive Recommended fonts"

LICENSE="BSD GPL-1+ GPL-2 LPPL-1.0 LPPL-1.1 LPPL-1.2 LPPL-1.3 LPPL-1.3c OFL-1.1 TeX TeX-other-free public-domain"
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
