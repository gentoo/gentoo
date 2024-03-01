# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-humanities.r68465
	adtrees.r51618
	bibleref.r55626
	bibleref-lds.r25526
	bibleref-mouth.r25527
	bibleref-parse.r22054
	covington.r69091
	diadia.r37656
	dramatist.r35866
	dvgloss.r29103
	ecltree.r15878
	edfnotes.r21540
	eledform.r38114
	eledmac.r45418
	expex.r44499
	expex-glossonly.r69713
	gb4e.r19216
	gmverse.r29803
	jura.r15878
	juraabbrev.r15878
	juramisc.r15878
	jurarsp.r15878
	langnames.r69101
	ledmac.r41811
	lexikon.r17364
	lexref.r36026
	ling-macros.r42268
	linguex.r30815
	liturg.r15878
	metrix.r52323
	nnext.r56575
	opbible.r68465
	parallel.r15878
	parrun.r15878
	phonrule.r43963
	plari.r15878
	play.r15878
	poemscol.r56082
	poetry.r53129
	poetrytex.r68353
	qobitree.r15878
	qtree.r15878
	reledmac.r68411
	rrgtrees.r27322
	rtklage.r15878
	screenplay.r27223
	screenplay-pkg.r44965
	sides.r15878
	stage.r62929
	textglos.r30788
	thalie.r65249
	tree-dvips.r21751
	verse.r34017
	xyling.r15878
"
TEXLIVE_MODULE_DOC_CONTENTS="
	adtrees.doc.r51618
	bibleref.doc.r55626
	bibleref-lds.doc.r25526
	bibleref-mouth.doc.r25527
	bibleref-parse.doc.r22054
	covington.doc.r69091
	diadia.doc.r37656
	dramatist.doc.r35866
	dvgloss.doc.r29103
	ecltree.doc.r15878
	edfnotes.doc.r21540
	eledform.doc.r38114
	eledmac.doc.r45418
	expex.doc.r44499
	expex-glossonly.doc.r69713
	gb4e.doc.r19216
	gmverse.doc.r29803
	jura.doc.r15878
	juraabbrev.doc.r15878
	juramisc.doc.r15878
	jurarsp.doc.r15878
	langnames.doc.r69101
	ledmac.doc.r41811
	lexikon.doc.r17364
	lexref.doc.r36026
	ling-macros.doc.r42268
	linguex.doc.r30815
	liturg.doc.r15878
	metrix.doc.r52323
	nnext.doc.r56575
	opbible.doc.r68465
	parallel.doc.r15878
	parrun.doc.r15878
	phonrule.doc.r43963
	plari.doc.r15878
	play.doc.r15878
	poemscol.doc.r56082
	poetry.doc.r53129
	poetrytex.doc.r68353
	qobitree.doc.r15878
	qtree.doc.r15878
	reledmac.doc.r68411
	rrgtrees.doc.r27322
	rtklage.doc.r15878
	screenplay.doc.r27223
	screenplay-pkg.doc.r44965
	sides.doc.r15878
	stage.doc.r62929
	textglos.doc.r30788
	thalie.doc.r65249
	theatre.doc.r45363
	tree-dvips.doc.r21751
	verse.doc.r34017
	xyling.doc.r15878
"
TEXLIVE_MODULE_SRC_CONTENTS="
	bibleref.source.r55626
	bibleref-lds.source.r25526
	bibleref-mouth.source.r25527
	dramatist.source.r35866
	dvgloss.source.r29103
	edfnotes.source.r21540
	eledform.source.r38114
	eledmac.source.r45418
	jura.source.r15878
	juraabbrev.source.r15878
	jurarsp.source.r15878
	langnames.source.r69101
	ledmac.source.r41811
	liturg.source.r15878
	metrix.source.r52323
	nnext.source.r56575
	parallel.source.r15878
	parrun.source.r15878
	plari.source.r15878
	play.source.r15878
	poemscol.source.r56082
	poetry.source.r53129
	poetrytex.source.r68353
	reledmac.source.r68411
	rrgtrees.source.r27322
	screenplay.source.r27223
	stage.source.r62929
	textglos.source.r30788
	verse.source.r34017
"

inherit texlive-module

DESCRIPTION="TeXLive Humanities packages"

LICENSE="GPL-1 LPPL-1.2 LPPL-1.3 LPPL-1.3c"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-latex-2023
	doc? ( app-text/sword )
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
BDEPEND="
	doc? ( virtual/pkgconfig )
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/diadia/diadia.lua
"

src_prepare() {
	default

	if use doc; then
		pushd texmf-dist/doc/luatex/opbible &> /dev/null || die

		# https://github.com/olsak/OpBible/pull/1
		eapply "${FILESDIR}"/${PN}-2023-opbible-improve-Makefile-respect-user-flags.patch
		# Remove the binary, so that it is rebuild.
		rm txs-gen/mod2tex || die

		popd &> /dev/null || die
	fi
}

src_compile() {
	if use doc; then
		emake -C texmf-dist/doc/luatex/opbible/txs-gen
	fi

	texlive-module_src_compile
}
