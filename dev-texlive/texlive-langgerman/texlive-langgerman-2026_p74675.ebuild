# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langgerman.r74675
	apalike-german.r76790
	autotype.r78931
	babel-german.r78737
	bibleref-german.r79618
	dehyph.r48599
	dehyph-exptl.r79618
	dhua.r79618
	dtk-bibliography.r78985
	fragoli.r79228
	german.r79618
	germbib.r76790
	germkorr.r15878
	hausarbeit-jura.r56070
	hyphen-german.r78069
	milog.r79618
	quran-de.r74874
	r_und_s.r15878
	schulmathematik.r76924
	termcal-de.r47111
	udesoftec.r57866
	uhrzeit.r79121
	umlaute.r79618
"
TEXLIVE_MODULE_SRC_CONTENTS="
	apalike-german.doc.r76790
	autotype.doc.r78931
	babel-german.doc.r78737
	bibleref-german.doc.r79618
	booktabs-de.doc.r79121
	csquotes-de.doc.r79121
	dehyph-exptl.doc.r79618
	dhua.doc.r79618
	dtk-bibliography.doc.r78985
	etdipa.doc.r76924
	etoolbox-de.doc.r79121
	fifinddo-info.doc.r79618
	fragoli.doc.r79228
	german.doc.r79618
	germbib.doc.r76790
	germkorr.doc.r15878
	hausarbeit-jura.doc.r56070
	koma-script-examples.doc.r63833
	l2picfaq.doc.r19601
	l2tabu.doc.r63708
	latexcheat-de.doc.r79618
	lshort-german.doc.r70740
	lualatex-doc-de.doc.r30474
	microtype-de.doc.r79121
	milog.doc.r79618
	quran-de.doc.r74874
	r_und_s.doc.r15878
	schulmathematik.doc.r76924
	templates-fenn.doc.r79121
	templates-sommer.doc.r79121
	termcal-de.doc.r47111
	texlive-de.doc.r74226
	tipa-de.doc.r79618
	translation-arsclassica-de.doc.r23803
	translation-biblatex-de.doc.r59382
	translation-chemsym-de.doc.r23804
	translation-ecv-de.doc.r24754
	translation-enumitem-de.doc.r24196
	translation-europecv-de.doc.r79618
	translation-filecontents-de.doc.r79618
	translation-moreverb-de.doc.r79618
	udesoftec.doc.r57866
	uhrzeit.doc.r79121
	umlaute.doc.r79618
	voss-mathcol.doc.r79618
"
TEXLIVE_MODULE_DOC_CONTENTS="
	babel-german.source.r78737
	dhua.source.r79618
	fifinddo-info.source.r79618
	german.source.r79618
	hausarbeit-jura.source.r56070
	termcal-de.source.r47111
	udesoftec.source.r57866
	umlaute.source.r79618
"

inherit texlive-module

DESCRIPTION="TeXLive German"

LICENSE="FDL-1.1+ GPL-1+ LPPL-1.0 LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT OPL TeX-other-free"
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
