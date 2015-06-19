# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-italian/texlive-documentation-italian-2012.ebuild,v 1.13 2013/04/25 21:26:41 ago Exp $

EAPI="4"

TEXLIVE_MODULE_CONTENTS="amsldoc-it amsmath-it amsthdoc-it fancyhdr-it l2tabu-italian latex4wp-it lshort-italian psfrag-italian texlive-it collection-documentation-italian
"
TEXLIVE_MODULE_DOC_CONTENTS="amsldoc-it.doc amsmath-it.doc amsthdoc-it.doc fancyhdr-it.doc l2tabu-italian.doc latex4wp-it.doc lshort-italian.doc psfrag-italian.doc texlive-it.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit  texlive-module
DESCRIPTION="TeXLive Italian documentation"

LICENSE="GPL-2 GPL-1 LPPL-1.3 TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2012
"
RDEPEND="${DEPEND} "
