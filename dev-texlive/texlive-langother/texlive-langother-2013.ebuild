# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langother/texlive-langother-2013.ebuild,v 1.1 2013/06/28 16:29:14 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="amsldoc-vn aramaic-serto babel-bahasa babel-esperanto babel-hebrew babel-interlingua babel-sorbian babel-thai babel-vietnamese cjhebrew ctib fonts-tlwg hyphen-afrikaans hyphen-coptic hyphen-esperanto hyphen-georgian hyphen-indonesian hyphen-interlingua hyphen-thai hyphen-turkmen lshort-thai lshort-vietnamese ntheorem-vn vntex collection-langother
"
TEXLIVE_MODULE_DOC_CONTENTS="amsldoc-vn.doc aramaic-serto.doc babel-bahasa.doc babel-esperanto.doc babel-hebrew.doc babel-interlingua.doc babel-sorbian.doc babel-thai.doc cjhebrew.doc ctib.doc fonts-tlwg.doc lshort-thai.doc lshort-vietnamese.doc ntheorem-vn.doc vntex.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-bahasa.source babel-esperanto.source babel-hebrew.source babel-interlingua.source babel-sorbian.source babel-thai.source babel-vietnamese.source ctib.source fonts-tlwg.source vntex.source "
inherit  texlive-module
DESCRIPTION="TeXLive Other languages"

LICENSE=" GPL-1 GPL-2 LGPL-2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2013
!<dev-texlive/texlive-basic-2009
!dev-texlive/texlive-documentation-vietnamese
!dev-texlive/texlive-langvietnamese
!<dev-texlive/texlive-langcjk-2013
!dev-texlive/texlive-langhebrew
!dev-texlive/texlive-documentation-thai
!dev-texlive/texlive-langturkmen
!dev-texlive/texlive-langtibetan
"
RDEPEND="${DEPEND} "
