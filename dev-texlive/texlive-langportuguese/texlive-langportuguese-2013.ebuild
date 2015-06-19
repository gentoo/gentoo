# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langportuguese/texlive-langportuguese-2013.ebuild,v 1.1 2013/06/28 16:31:15 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="babel-portuges beamer-tut-pt cursolatex hyphen-portuguese latexcheat-ptbr lshort-portuguese ordinalpt xypic-tut-pt collection-langportuguese
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-portuges.doc beamer-tut-pt.doc cursolatex.doc latexcheat-ptbr.doc lshort-portuguese.doc ordinalpt.doc xypic-tut-pt.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-portuges.source ordinalpt.source "
inherit  texlive-module
DESCRIPTION="TeXLive Portuguese"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2013
!dev-texlive/texlive-documentation-portuguese
"
RDEPEND="${DEPEND} "
