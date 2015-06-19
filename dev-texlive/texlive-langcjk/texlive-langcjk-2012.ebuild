# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langcjk/texlive-langcjk-2012.ebuild,v 1.16 2013/04/25 21:27:46 ago Exp $

EAPI="4"

TEXLIVE_MODULE_CONTENTS="adobemapping arphic c90 cjkpunct cns ctex dnp fonts-tlwg garuda-c90 hyphen-chinese ipaex japanese japanese-otf japanese-otf-uptex jfontmaps jsclasses luatexja norasi-c90 ptex thailatex uhc uptex wadalab xpinyin zhmetrics zhnumber zhspacing collection-langcjk
"
TEXLIVE_MODULE_DOC_CONTENTS="arphic.doc c90.doc cjkpunct.doc cns.doc ctex.doc fonts-tlwg.doc ipaex.doc japanese.doc japanese-otf.doc japanese-otf-uptex.doc jfontmaps.doc luatexja.doc ptex.doc thailatex.doc uhc.doc uptex.doc wadalab.doc xpinyin.doc zhmetrics.doc zhnumber.doc zhspacing.doc "
TEXLIVE_MODULE_SRC_CONTENTS="c90.source cjkpunct.source fonts-tlwg.source garuda-c90.source japanese.source japanese-otf.source japanese-otf-uptex.source jsclasses.source luatexja.source norasi-c90.source ptex.source thailatex.source uptex.source xpinyin.source zhmetrics.source zhnumber.source "
inherit  texlive-module
DESCRIPTION="TeXLive Chinese, Japanese, Korean"

LICENSE="GPL-2 BSD GPL-1 GPL-3 LPPL-1.3 TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2012
>=app-text/texlive-core-2010[cjk]
>=dev-texlive/texlive-latex-2011
!!<dev-texlive/texlive-langcjk-2012
"
RDEPEND="${DEPEND} dev-lang/ruby
"
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/jfontmaps/updmap-setup-kanji.pl
	texmf-dist/scripts/uptex/convbkmk.rb
"

# Avoids collision with app-text/ttf2pk2
src_prepare() {
	local i=texmf-dist/source/fonts/zhmetrics/ttfonts.map
	[ -f "${i}" ] && rm -f "${i}"
}
