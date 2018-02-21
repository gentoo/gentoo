# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="babel-japanese bxbase bxcjkjatype bxjalipsum bxjscls bxorigcapt convbkmk ifptex ipaex japanese-otf japanese-otf-uptex jlreq jsclasses lshort-japanese luatexja mendex-doc pbibtex-base platex platex-tools platexcheat ptex ptex-base ptex-fonts ptex-fontmaps ptex2pdf pxbase pxchfon pxcjkcat pxjahyper pxrubrica uplatex uptex uptex-base uptex-fonts wadalab zxjafbfont zxjatype collection-langjapanese
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-japanese.doc bxbase.doc bxcjkjatype.doc bxjalipsum.doc bxjscls.doc bxorigcapt.doc convbkmk.doc ifptex.doc ipaex.doc japanese-otf.doc japanese-otf-uptex.doc jlreq.doc jsclasses.doc lshort-japanese.doc luatexja.doc mendex-doc.doc pbibtex-base.doc platex.doc platex-tools.doc platexcheat.doc ptex.doc ptex-base.doc ptex-fonts.doc ptex-fontmaps.doc ptex2pdf.doc pxbase.doc pxchfon.doc pxcjkcat.doc pxjahyper.doc pxrubrica.doc uplatex.doc uptex.doc uptex-base.doc uptex-fonts.doc wadalab.doc zxjafbfont.doc zxjatype.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-japanese.source bxjscls.source japanese-otf.source japanese-otf-uptex.source jsclasses.source luatexja.source platex.source ptex-fontmaps.source pxrubrica.source uplatex.source uptex-fonts.source "
inherit  texlive-module
DESCRIPTION="TeXLive Japanese"

LICENSE=" BSD BSD-2 GPL-1 GPL-2 GPL-3 LPPL-1.3 MIT public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-langcjk-2017
!<dev-texlive/texlive-langcjk-2014
!<dev-texlive/texlive-basic-2016
"
RDEPEND="${DEPEND} dev-lang/ruby
"
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/convbkmk/convbkmk.rb
	texmf-dist/scripts/ptex2pdf/ptex2pdf.lua
	texmf-dist/scripts/ptex-fontmaps/kanji-config-updmap-sys.sh
	texmf-dist/scripts/ptex-fontmaps/kanji-config-updmap-user.sh
	texmf-dist/scripts/ptex-fontmaps/kanji-config-updmap.pl
	texmf-dist/scripts/ptex-fontmaps/kanji-fontmap-creator.pl
"
