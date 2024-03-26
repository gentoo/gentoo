# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langarabic.r69111
	alkalami.r44497
	alpha-persian.r66115
	amiri.r65191
	arabi.r44662
	arabi-add.r67573
	arabic-book.r59594
	arabluatex.r67201
	arabtex.r64260
	bidi.r67798
	bidihl.r37795
	dad.r54191
	ghab.r29803
	hvarabic.r59423
	imsproc.r29803
	iran-bibtex.r69347
	khatalmaqala.r68280
	kurdishlipsum.r47518
	luabidi.r68432
	na-box.r45130
	parsimatn.r69090
	parsinevis.r68395
	persian-bib.r37297
	quran.r67791
	sexam.r46628
	simurgh.r31719
	texnegar.r57692
	tram.r29803
	xepersian.r68117
	xepersian-hm.r56272
"
TEXLIVE_MODULE_DOC_CONTENTS="
	alkalami.doc.r44497
	alpha-persian.doc.r66115
	amiri.doc.r65191
	arabi.doc.r44662
	arabi-add.doc.r67573
	arabic-book.doc.r59594
	arabluatex.doc.r67201
	arabtex.doc.r64260
	bidi.doc.r67798
	bidihl.doc.r37795
	dad.doc.r54191
	ghab.doc.r29803
	hvarabic.doc.r59423
	imsproc.doc.r29803
	iran-bibtex.doc.r69347
	khatalmaqala.doc.r68280
	kurdishlipsum.doc.r47518
	lshort-persian.doc.r31296
	luabidi.doc.r68432
	na-box.doc.r45130
	parsimatn.doc.r69090
	parsinevis.doc.r68395
	persian-bib.doc.r37297
	quran.doc.r67791
	sexam.doc.r46628
	simurgh.doc.r31719
	texnegar.doc.r57692
	tram.doc.r29803
	xepersian.doc.r68117
	xepersian-hm.doc.r56272
	xindy-persian.doc.r59013
"
TEXLIVE_MODULE_SRC_CONTENTS="
	arabluatex.source.r67201
	bidi.source.r67798
	texnegar.source.r57692
	xepersian.source.r68117
	xepersian-hm.source.r56272
"

inherit texlive-module

DESCRIPTION="TeXLive Arabic"

LICENSE="CC-BY-SA-4.0 GPL-2 GPL-3+ LPPL-1.3 LPPL-1.3c MIT OFL public-domain"
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
