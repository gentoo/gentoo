# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langcjk/texlive-langcjk-2013.ebuild,v 1.1 2013/06/28 16:20:09 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="adobemapping arphic asymptote-by-example-zh-cn asymptote-faq-zh-cn asymptote-manual-zh-cn bxbase bxjscls c90 cjk-ko cjkpunct cns convbkmk ctex ctex-faq dnp garuda-c90 hyphen-chinese ipaex japanese japanese-otf japanese-otf-uptex jfontmaps jsclasses latex-notes-zh-cn lshort-chinese lshort-japanese lshort-korean luatexja nanumtype1 norasi-c90 ptex ptex2pdf pxbase pxchfon pxcjkcat pxjahyper pxrubrica texlive-zh-cn uhc uptex wadalab xpinyin zhmetrics zhnumber zhspacing zxjafbfont zxjafont zxjatype collection-langcjk
"
TEXLIVE_MODULE_DOC_CONTENTS="arphic.doc asymptote-by-example-zh-cn.doc asymptote-faq-zh-cn.doc asymptote-manual-zh-cn.doc bxbase.doc bxjscls.doc c90.doc cjk-ko.doc cjkpunct.doc cns.doc convbkmk.doc ctex.doc ctex-faq.doc ipaex.doc japanese.doc japanese-otf.doc japanese-otf-uptex.doc jfontmaps.doc jsclasses.doc latex-notes-zh-cn.doc lshort-chinese.doc lshort-japanese.doc lshort-korean.doc luatexja.doc nanumtype1.doc ptex.doc ptex2pdf.doc pxbase.doc pxchfon.doc pxcjkcat.doc pxjahyper.doc pxrubrica.doc texlive-zh-cn.doc uhc.doc uptex.doc wadalab.doc xpinyin.doc zhmetrics.doc zhnumber.doc zhspacing.doc zxjafbfont.doc zxjafont.doc zxjatype.doc "
TEXLIVE_MODULE_SRC_CONTENTS="bxjscls.source c90.source cjkpunct.source garuda-c90.source japanese.source japanese-otf.source japanese-otf-uptex.source jfontmaps.source jsclasses.source luatexja.source norasi-c90.source ptex.source pxchfon.source pxrubrica.source uptex.source xpinyin.source zhmetrics.source zhnumber.source "
inherit  texlive-module
DESCRIPTION="TeXLive Chinese/Japanese/Korean"

LICENSE=" BSD FDL-1.1 GPL-1 GPL-2 GPL-3 LGPL-2 LPPL-1.3 OFL TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2013
>=app-text/texlive-core-2010[cjk]
>=dev-texlive/texlive-latex-2011
!!<dev-texlive/texlive-langcjk-2012
!dev-texlive/texlive-documentation-chinese
!dev-texlive/texlive-documentation-korean
!dev-texlive/texlive-documentation-japanese
"
RDEPEND="${DEPEND} dev-lang/ruby
"
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/convbkmk/convbkmk.rb
	texmf-dist/scripts/ptex2pdf/ptex2pdf.lua
"

# Avoids collision with app-text/ttf2pk2
src_prepare() {
	local i=texmf-dist/source/fonts/zhmetrics/ttfonts.map
	[ -f "${i}" ] && rm -f "${i}"
}
