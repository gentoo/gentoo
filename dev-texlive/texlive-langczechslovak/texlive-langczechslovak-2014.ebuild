# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langczechslovak/texlive-langczechslovak-2014.ebuild,v 1.4 2015/07/12 17:48:49 zlogene Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="babel-czech babel-slovak cnbwp cs csbulletin cslatex csplain cstex hyphen-czech hyphen-slovak lshort-czech lshort-slovak texlive-cz collection-langczechslovak
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-czech.doc babel-slovak.doc cnbwp.doc csbulletin.doc cstex.doc lshort-czech.doc lshort-slovak.doc texlive-cz.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-czech.source babel-slovak.source cslatex.source "
inherit  texlive-module
DESCRIPTION="TeXLive Czech/Slovak"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
>=dev-texlive/texlive-latex-2014
!dev-texlive/texlive-documentation-czechslovak
>=app-text/texlive-core-2014[xetex]
"
RDEPEND="${DEPEND} "
