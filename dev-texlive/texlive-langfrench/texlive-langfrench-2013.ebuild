# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langfrench/texlive-langfrench-2013.ebuild,v 1.1 2013/06/28 16:24:11 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="aeguill apprends-latex babel-basque babel-french basque-book basque-date bib-fr bibleref-french booktabs-fr droit-fr epslatex-fr facture frenchle frletter hyphen-basque hyphen-french impatient-fr impnattypo l2tabu-french lshort-french mafr tabvar tdsfrmath texlive-fr translation-array-fr translation-dcolumn-fr translation-natbib-fr translation-tabbing-fr variations collection-langfrench
"
TEXLIVE_MODULE_DOC_CONTENTS="aeguill.doc apprends-latex.doc babel-basque.doc babel-french.doc basque-book.doc basque-date.doc bib-fr.doc bibleref-french.doc booktabs-fr.doc droit-fr.doc epslatex-fr.doc facture.doc frenchle.doc frletter.doc impatient-fr.doc impnattypo.doc l2tabu-french.doc lshort-french.doc mafr.doc tabvar.doc tdsfrmath.doc texlive-fr.doc translation-array-fr.doc translation-dcolumn-fr.doc translation-natbib-fr.doc translation-tabbing-fr.doc variations.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-basque.source babel-french.source basque-book.source basque-date.source bibleref-french.source facture.source impnattypo.source tabvar.source tdsfrmath.source "
inherit  texlive-module
DESCRIPTION="TeXLive French"

LICENSE=" FDL-1.1 GPL-1 GPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2013
!dev-texlive/texlive-documentation-french
"
RDEPEND="${DEPEND} "
