# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="bxbase bxcjkjatype bxjscls convbkmk ipaex japanese japanese-otf japanese-otf-uptex jfontmaps jsclasses lshort-japanese luatexja ptex ptex2pdf pxbase pxchfon pxcjkcat pxjahyper pxrubrica uptex wadalab zxjafbfont zxjatype collection-langjapanese
"
TEXLIVE_MODULE_DOC_CONTENTS="bxbase.doc bxcjkjatype.doc bxjscls.doc convbkmk.doc ipaex.doc japanese.doc japanese-otf.doc japanese-otf-uptex.doc jfontmaps.doc jsclasses.doc lshort-japanese.doc luatexja.doc ptex.doc ptex2pdf.doc pxbase.doc pxchfon.doc pxcjkcat.doc pxjahyper.doc pxrubrica.doc uptex.doc wadalab.doc zxjafbfont.doc zxjatype.doc "
TEXLIVE_MODULE_SRC_CONTENTS="bxjscls.source japanese.source japanese-otf.source japanese-otf-uptex.source jfontmaps.source jsclasses.source luatexja.source ptex.source pxrubrica.source uptex.source "
inherit  texlive-module
DESCRIPTION="TeXLive Japanese"

LICENSE=" BSD GPL-1 GPL-2 LPPL-1.3 TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-langcjk-2015
!<dev-texlive/texlive-langcjk-2014
"
RDEPEND="${DEPEND} dev-lang/ruby
"
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/convbkmk/convbkmk.rb
	texmf-dist/scripts/ptex2pdf/ptex2pdf.lua
	texmf-dist/scripts/jfontmaps/kanji-config-updmap-sys.sh
	texmf-dist/scripts/jfontmaps/kanji-config-updmap.pl
	texmf-dist/scripts/jfontmaps/kanji-fontmap-creator.pl
"
