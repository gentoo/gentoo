# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-langenglish.r68790
	hyphen-english.r58609
	latexfileinfo-pkgs.r26760
	macros2e.r64967
	quran-en.r68790
"
TEXLIVE_MODULE_DOC_CONTENTS="
	amiweb2c-guide.doc.r56878
	amscls-doc.doc.r46110
	amslatex-primer.doc.r28980
	around-the-bend.doc.r15878
	ascii-chart.doc.r20536
	biblatex-cheatsheet.doc.r44685
	components.doc.r63184
	comprehensive.doc.r69619
	dickimaw.doc.r32925
	docsurvey.doc.r69417
	drawing-with-metapost.doc.r66846
	dtxtut.doc.r69587
	first-latex-doc.doc.r15878
	fontinstallationguide.doc.r59755
	forest-quickstart.doc.r55688
	gentle.doc.r15878
	guide-to-latex.doc.r45712
	happy4th.doc.r25020
	impatient.doc.r54080
	intro-scientific.doc.r15878
	knuth-errata.doc.r58682
	knuth-hint.doc.r67373
	knuth-pdf.doc.r67332
	l2tabu-english.doc.r15878
	latex-brochure.doc.r40612
	latex-course.doc.r68681
	latex-doc-ptr.doc.r57311
	latex-for-undergraduates.doc.r64647
	latex-graphics-companion.doc.r29235
	latex-refsheet.doc.r45076
	latex-veryshortguide.doc.r55228
	latex-web-companion.doc.r29349
	latex2e-help-texinfo.doc.r65552
	latex4wp.doc.r68096
	latexcheat.doc.r15878
	latexcourse-rug.doc.r39026
	latexfileinfo-pkgs.doc.r26760
	lshort-english.doc.r58309
	macros2e.doc.r64967
	math-into-latex-4.doc.r44131
	maths-symbols.doc.r37763
	memdesign.doc.r48664
	memoirchapterstyles.doc.r59766
	metafont-beginners.doc.r29803
	metapost-examples.doc.r15878
	patgen2-tutorial.doc.r58841
	pictexsum.doc.r24965
	plain-doc.doc.r28424
	quran-en.doc.r68790
	short-math-guide.doc.r46126
	simplified-latex.doc.r20620
	svg-inkscape.doc.r32199
	tamethebeast.doc.r15878
	tds.doc.r64477
	tex-font-errors-cheatsheet.doc.r18314
	tex-nutshell.doc.r67213
	tex-overview.doc.r41403
	tex-refs.doc.r57349
	tex-vpat.doc.r66758
	texbytopic.doc.r68950
	texonly.doc.r50985
	titlepages.doc.r19457
	tlc2.doc.r26096
	tlc3-examples.doc.r65496
	tlmgrbasics.doc.r68999
	undergradmath.doc.r57286
	visualfaq.doc.r61719
	webguide.doc.r25813
	xetexref.doc.r68072
	yet-another-guide-latex2e.doc.r68564
"
TEXLIVE_MODULE_SRC_CONTENTS="
	latexfileinfo-pkgs.source.r26760
"

inherit texlive-module

DESCRIPTION="TeXLive US and UK English"

LICENSE="CC-BY-3.0 CC-BY-SA-4.0 FDL-1.1 GPL-1 GPL-2 GPL-2+ LPPL-1.2 LPPL-1.3 LPPL-1.3c OPL TeX TeX-other-free public-domain"
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
