# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langenglish.r78607
	hyphen-english.r78069
	latexfileinfo-pkgs.r79618
	macros2e.r77050
	quran-en.r74874
"
TEXLIVE_MODULE_SRC_CONTENTS="
	amiweb2c-guide.doc.r56878
	amscls-doc.doc.r46110
	amslatex-primer.doc.r79618
	around-the-bend.doc.r15878
	ascii-chart.doc.r20536
	asy-overview.doc.r72484
	biblatex-cheatsheet.doc.r44685
	components.doc.r63184
	comprehensive.doc.r78693
	dickimaw.doc.r79618
	docsurvey.doc.r70729
	drawing-with-metapost.doc.r72705
	dtxtut.doc.r69587
	first-latex-doc.doc.r15878
	fontinstallationguide.doc.r59755
	forest-quickstart.doc.r55688
	gentle.doc.r15878
	guide-to-latex.doc.r45712
	happy4th.doc.r25020
	impatient.doc.r54080
	intro-scientific.doc.r79618
	knuth-errata.doc.r58682
	knuth-hint.doc.r78243
	knuth-pdf.doc.r78242
	l2tabu-english.doc.r15878
	latex-brochure.doc.r40612
	latex-course.doc.r68681
	latex-doc-ptr.doc.r77050
	latex-for-undergraduates.doc.r70199
	latex-graphics-companion.doc.r29235
	latex-refsheet.doc.r45076
	latex-veryshortguide.doc.r79618
	latex-web-companion.doc.r29349
	latex2e-help-texinfo.doc.r79327
	latex4wp.doc.r68096
	latexcheat.doc.r15878
	latexcourse-rug.doc.r39026
	latexfileinfo-pkgs.doc.r79618
	lshort-english.doc.r79618
	macros2e.doc.r77050
	math-into-latex-4.doc.r44131
	maths-symbols.doc.r37763
	memdesign.doc.r48664
	memoirchapterstyles.doc.r79618
	metafont-beginners.doc.r29803
	metapost-examples.doc.r15878
	patgen2-tutorial.doc.r58841
	pictexsum.doc.r24965
	plain-doc.doc.r28424
	quran-en.doc.r74874
	short-math-guide.doc.r46126
	simplified-latex.doc.r20620
	svg-inkscape.doc.r32199
	tamethebeast.doc.r15878
	tds.doc.r64477
	tex-font-errors-cheatsheet.doc.r79618
	tex-nutshell.doc.r70375
	tex-overview.doc.r41403
	tex-vpat.doc.r72067
	texbytopic.doc.r68950
	texonly.doc.r76924
	titlepages.doc.r79618
	tlc2.doc.r79618
	tlc3-examples.doc.r65496
	tlmgrbasics.doc.r79665
	typstfun.doc.r70018
	undergradmath.doc.r57286
	visualfaq.doc.r79618
	webguide.doc.r77050
	wrapstuff-doc-en.doc.r71835
	yet-another-guide-latex2e.doc.r77842
"
TEXLIVE_MODULE_DOC_CONTENTS="
	latexfileinfo-pkgs.source.r79618
"

inherit texlive-module

DESCRIPTION="TeXLive US and UK English"

LICENSE="CC-BY-3.0 CC-BY-SA-4.0 FDL-1.1+ GPL-1+ GPL-2 GPL-2+ LPPL-1.2 LPPL-1.3 LPPL-1.3c OPL TeX TeX-other-free public-domain"
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
