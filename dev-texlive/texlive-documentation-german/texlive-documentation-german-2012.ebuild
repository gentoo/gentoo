# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-german/texlive-documentation-german-2012.ebuild,v 1.13 2013/04/25 21:26:38 ago Exp $

EAPI="4"

TEXLIVE_MODULE_CONTENTS="einfuehrung fifinddo-info kopka l2picfaq l2tabu latex-bib-ex latex-referenz latex-tabellen lshort-german presentations pstricks-examples templates-fenn templates-sommer texlive-de translation-arsclassica-de translation-biblatex-de translation-chemsym-de translation-ecv-de translation-enumitem-de translation-europecv-de translation-filecontents-de translation-moreverb-de voss-de collection-documentation-german
"
TEXLIVE_MODULE_DOC_CONTENTS="einfuehrung.doc fifinddo-info.doc kopka.doc l2picfaq.doc l2tabu.doc latex-bib-ex.doc latex-referenz.doc latex-tabellen.doc lshort-german.doc presentations.doc pstricks-examples.doc templates-fenn.doc templates-sommer.doc texlive-de.doc translation-arsclassica-de.doc translation-biblatex-de.doc translation-chemsym-de.doc translation-ecv-de.doc translation-enumitem-de.doc translation-europecv-de.doc translation-filecontents-de.doc translation-moreverb-de.doc voss-de.doc "
TEXLIVE_MODULE_SRC_CONTENTS="fifinddo-info.source "
inherit  texlive-module
DESCRIPTION="TeXLive German documentation"

LICENSE="GPL-2 FDL-1.1 GPL-1 LPPL-1.3 TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2012
"
RDEPEND="${DEPEND} "
