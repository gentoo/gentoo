# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TEXLIVE_MODULE_CONTENTS="
	collection-langfrench.r67951
	aeguill.r15878
	annee-scolaire.r55988
	babel-basque.r30256
	babel-french.r69205
	basque-book.r32924
	basque-date.r26477
	bib-fr.r15878
	bibleref-french.r53138
	cahierprof.r68148
	couleurs-fr.r67901
	droit-fr.r39802
	e-french.r52027
	facture.r67538
	frenchmath.r69568
	frletter.r15878
	frpseudocode.r56088
	hyphen-basque.r58652
	hyphen-french.r58652
	impnattypo.r50227
	letgut.r67192
	mafr.r15878
	matapli.r62632
	panneauxroute.r67951
	profcollege.r69539
	proflabo.r63147
	proflycee.r69749
	profsio.r69745
	tabvar.r63921
	tdsfrmath.r15878
	variations.r15878
"
TEXLIVE_MODULE_DOC_CONTENTS="
	aeguill.doc.r15878
	annee-scolaire.doc.r55988
	apprendre-a-programmer-en-tex.doc.r57179
	apprends-latex.doc.r19306
	babel-basque.doc.r30256
	babel-french.doc.r69205
	basque-book.doc.r32924
	basque-date.doc.r26477
	bib-fr.doc.r15878
	bibleref-french.doc.r53138
	booktabs-fr.doc.r21948
	cahierprof.doc.r68148
	couleurs-fr.doc.r67901
	droit-fr.doc.r39802
	e-french.doc.r52027
	epslatex-fr.doc.r19440
	expose-expl3-dunkerque-2019.doc.r54451
	facture.doc.r67538
	formation-latex-ul.doc.r68791
	frenchmath.doc.r69568
	frletter.doc.r15878
	frpseudocode.doc.r56088
	impatient-fr.doc.r54080
	impnattypo.doc.r50227
	l2tabu-french.doc.r31315
	latex2e-help-texinfo-fr.doc.r64228
	letgut.doc.r67192
	lshort-french.doc.r23332
	mafr.doc.r15878
	matapli.doc.r62632
	panneauxroute.doc.r67951
	profcollege.doc.r69539
	proflabo.doc.r63147
	proflycee.doc.r69749
	profsio.doc.r69745
	tabvar.doc.r63921
	tdsfrmath.doc.r15878
	texlive-fr.doc.r66571
	translation-array-fr.doc.r24344
	translation-dcolumn-fr.doc.r24345
	translation-natbib-fr.doc.r25105
	translation-tabbing-fr.doc.r24228
	variations.doc.r15878
	visualfaq-fr.doc.r67718
	visualtikz.doc.r54080
"
TEXLIVE_MODULE_SRC_CONTENTS="
	annee-scolaire.source.r55988
	babel-basque.source.r30256
	babel-french.source.r69205
	basque-book.source.r32924
	basque-date.source.r26477
	bibleref-french.source.r53138
	facture.source.r67538
	formation-latex-ul.source.r68791
	frenchmath.source.r69568
	hyphen-basque.source.r58652
	impnattypo.source.r50227
	letgut.source.r67192
	tabvar.source.r63921
	tdsfrmath.source.r15878
"

inherit texlive-module

DESCRIPTION="TeXLive French"

LICENSE="CC-BY-4.0 CC-BY-SA-2.0 CC-BY-SA-3.0 FDL-1.1+ GPL-1+ LPPL-1.0 LPPL-1.2 LPPL-1.3 LPPL-1.3c TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2023
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
