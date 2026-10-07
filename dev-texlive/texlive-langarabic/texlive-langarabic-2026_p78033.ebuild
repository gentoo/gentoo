# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langarabic.r78033
	alkalami.r79618
	alpha-persian.r79618
	amiri.r79618
	arabi.r79618
	arabi-add.r67573
	arabic-book.r59594
	arabluatex.r79618
	arabtex.r79618
	awami.r76980
	bidi.r77682
	bidihl.r77682
	dad.r54191
	fariscovernew.r78508
	ghab.r79618
	hvarabic.r76924
	hyphen-arabic.r74115
	hyphen-farsi.r74115
	imsproc.r29803
	iran-bibtex.r76790
	khatalmaqala.r68280
	kurdishlipsum.r79618
	luabidi.r79256
	mohe-book.r74912
	na-box.r45130
	parsimatn.r70775
	parsinevis.r70776
	persian-bib.r76790
	quran.r78362
	sexam.r46628
	simurgh.r31719
	texnegar.r76924
	tram.r79618
	xepersian.r77682
	xepersian-hm.r77682
"
TEXLIVE_MODULE_SRC_CONTENTS="
	alkalami.doc.r79618
	alpha-persian.doc.r79618
	amiri.doc.r79618
	arabi.doc.r79618
	arabi-add.doc.r67573
	arabic-book.doc.r59594
	arabluatex.doc.r79618
	arabtex.doc.r79618
	awami.doc.r76980
	bidi.doc.r77682
	bidihl.doc.r77682
	dad.doc.r54191
	fariscovernew.doc.r78508
	ghab.doc.r79618
	hvarabic.doc.r76924
	imsproc.doc.r29803
	iran-bibtex.doc.r76790
	khatalmaqala.doc.r68280
	kurdishlipsum.doc.r79618
	lshort-persian.doc.r79461
	luabidi.doc.r79256
	mohe-book.doc.r74912
	na-box.doc.r45130
	parsimatn.doc.r70775
	parsinevis.doc.r70776
	persian-bib.doc.r76790
	quran.doc.r78362
	sexam.doc.r46628
	simurgh.doc.r31719
	texnegar.doc.r76924
	tram.doc.r79618
	xepersian.doc.r77682
	xepersian-hm.doc.r77682
	xindy-persian.doc.r59013
"
TEXLIVE_MODULE_DOC_CONTENTS="
	arabluatex.source.r79618
	bidi.source.r77682
	texnegar.source.r76924
	xepersian.source.r77682
	xepersian-hm.source.r77682
"

inherit texlive-module

DESCRIPTION="TeXLive Arabic"

LICENSE="CC-BY-SA-4.0 GPL-2 GPL-2+ GPL-3+ LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT OFL-1.1"
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
