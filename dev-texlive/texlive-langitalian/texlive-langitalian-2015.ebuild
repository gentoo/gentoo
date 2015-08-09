# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="amsldoc-it amsmath-it amsthdoc-it babel-italian codicefiscaleitaliano fancyhdr-it fixltxhyph frontespizio hyphen-italian itnumpar l2tabu-italian latex4wp-it layaureo lshort-italian psfrag-italian texlive-it collection-langitalian
"
TEXLIVE_MODULE_DOC_CONTENTS="amsldoc-it.doc amsmath-it.doc amsthdoc-it.doc babel-italian.doc codicefiscaleitaliano.doc fancyhdr-it.doc fixltxhyph.doc frontespizio.doc itnumpar.doc l2tabu-italian.doc latex4wp-it.doc layaureo.doc lshort-italian.doc psfrag-italian.doc texlive-it.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-italian.source codicefiscaleitaliano.source fixltxhyph.source frontespizio.source itnumpar.source layaureo.source "
inherit  texlive-module
DESCRIPTION="TeXLive Italian"

LICENSE=" FDL-1.1 GPL-1 GPL-2 LPPL-1.3 TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2015
!dev-texlive/texlive-documentation-italian
"
RDEPEND="${DEPEND} "
