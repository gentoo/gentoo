# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langgerman.r68711
	apalike-german.r65403
	autotype.r69309
	babel-german.r69506
	bibleref-german.r21923
	dehyph.r48599
	dehyph-exptl.r66390
	dhua.r24035
	dtk-bibliography.r69155
	german.r42428
	germbib.r15878
	germkorr.r15878
	hausarbeit-jura.r56070
	hyphen-german.r59807
	milog.r41610
	quran-de.r54191
	r_und_s.r15878
	schulmathematik.r69244
	termcal-de.r47111
	udesoftec.r57866
	uhrzeit.r39570
	umlaute.r15878
"
TEXLIVE_MODULE_DOC_CONTENTS="
	apalike-german.doc.r65403
	autotype.doc.r69309
	babel-german.doc.r69506
	bibleref-german.doc.r21923
	booktabs-de.doc.r21907
	csquotes-de.doc.r23371
	dehyph-exptl.doc.r66390
	dhua.doc.r24035
	dtk-bibliography.doc.r69155
	etdipa.doc.r36354
	etoolbox-de.doc.r21906
	fifinddo-info.doc.r29349
	german.doc.r42428
	germbib.doc.r15878
	germkorr.doc.r15878
	hausarbeit-jura.doc.r56070
	koma-script-examples.doc.r63833
	l2picfaq.doc.r19601
	l2tabu.doc.r63708
	latexcheat-de.doc.r35702
	lshort-german.doc.r55643
	lualatex-doc-de.doc.r30474
	microtype-de.doc.r54080
	milog.doc.r41610
	quran-de.doc.r54191
	r_und_s.doc.r15878
	schulmathematik.doc.r69244
	templates-fenn.doc.r15878
	templates-sommer.doc.r15878
	termcal-de.doc.r47111
	texlive-de.doc.r67108
	tipa-de.doc.r22005
	translation-arsclassica-de.doc.r23803
	translation-biblatex-de.doc.r59382
	translation-chemsym-de.doc.r23804
	translation-ecv-de.doc.r24754
	translation-enumitem-de.doc.r24196
	translation-europecv-de.doc.r23840
	translation-filecontents-de.doc.r24010
	translation-moreverb-de.doc.r23957
	udesoftec.doc.r57866
	uhrzeit.doc.r39570
	umlaute.doc.r15878
	voss-mathcol.doc.r32954
"
TEXLIVE_MODULE_SRC_CONTENTS="
	babel-german.source.r69506
	dhua.source.r24035
	fifinddo-info.source.r29349
	german.source.r42428
	hausarbeit-jura.source.r56070
	termcal-de.source.r47111
	udesoftec.source.r57866
	umlaute.source.r15878
"

inherit texlive-module

DESCRIPTION="TeXLive German"

LICENSE="FDL-1.1 GPL-1 LPPL-1.3 LPPL-1.3c MIT OPL TeX-other-free"
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
