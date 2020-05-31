# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="aeguill apprendre-a-programmer-en-tex apprends-latex babel-basque babel-french basque-book basque-date bib-fr bibleref-french booktabs-fr droit-fr e-french epslatex-fr expose-expl3-dunkerque-2019 facture formation-latex-ul frenchmath frletter hyphen-basque hyphen-french impatient-fr impnattypo l2tabu-french latex2e-help-texinfo-fr lshort-french mafr tabvar tdsfrmath texlive-fr translation-array-fr translation-dcolumn-fr translation-natbib-fr translation-tabbing-fr variations visualtikz collection-langfrench
"
TEXLIVE_MODULE_DOC_CONTENTS="aeguill.doc apprendre-a-programmer-en-tex.doc apprends-latex.doc babel-basque.doc babel-french.doc basque-book.doc basque-date.doc bib-fr.doc bibleref-french.doc booktabs-fr.doc droit-fr.doc e-french.doc epslatex-fr.doc expose-expl3-dunkerque-2019.doc facture.doc formation-latex-ul.doc frenchmath.doc frletter.doc impatient-fr.doc impnattypo.doc l2tabu-french.doc latex2e-help-texinfo-fr.doc lshort-french.doc mafr.doc tabvar.doc tdsfrmath.doc texlive-fr.doc translation-array-fr.doc translation-dcolumn-fr.doc translation-natbib-fr.doc translation-tabbing-fr.doc variations.doc visualtikz.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-basque.source babel-french.source basque-book.source basque-date.source bibleref-french.source facture.source formation-latex-ul.source frenchmath.source hyphen-basque.source impnattypo.source tabvar.source tdsfrmath.source "
inherit  texlive-module
DESCRIPTION="TeXLive French"

LICENSE=" GPL-2 CC-BY-SA-4.0 "
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
"
RDEPEND="${DEPEND} "
