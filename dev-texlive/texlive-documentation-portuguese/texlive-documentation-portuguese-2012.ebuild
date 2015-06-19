# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-portuguese/texlive-documentation-portuguese-2012.ebuild,v 1.12 2013/04/25 21:26:51 ago Exp $

EAPI="4"

TEXLIVE_MODULE_CONTENTS="beamer-tut-pt cursolatex latexcheat-ptbr lshort-portuguese xypic-tut-pt collection-documentation-portuguese
"
TEXLIVE_MODULE_DOC_CONTENTS="beamer-tut-pt.doc cursolatex.doc latexcheat-ptbr.doc lshort-portuguese.doc xypic-tut-pt.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit  texlive-module
DESCRIPTION="TeXLive Portuguese documentation"

LICENSE="GPL-2 GPL-1 LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2012
"
RDEPEND="${DEPEND} "
