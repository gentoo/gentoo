# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langkorean/texlive-langkorean-2014.ebuild,v 1.3 2015/07/12 17:56:41 zlogene Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="cjk-ko kotex-oblivoir kotex-plain kotex-utf kotex-utils lshort-korean nanumtype1 uhc collection-langkorean
"
TEXLIVE_MODULE_DOC_CONTENTS="cjk-ko.doc kotex-oblivoir.doc kotex-plain.doc kotex-utf.doc kotex-utils.doc lshort-korean.doc nanumtype1.doc uhc.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit  texlive-module
DESCRIPTION="TeXLive Korean"

LICENSE=" FDL-1.1 GPL-2 LPPL-1.3 OFL TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-langcjk-2014
!<dev-texlive/texlive-langcjk-2014
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/kotex-utils/komkindex.pl
	texmf-dist/scripts/kotex-utils/jamo-normalize.pl
	texmf-dist/scripts/kotex-utils/ttf2kotexfont.pl
"
