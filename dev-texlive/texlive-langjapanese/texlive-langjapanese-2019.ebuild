# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="ascmac babel-japanese bxbase bxcjkjatype bxjaholiday bxjalipsum bxjaprnind bxjscls bxorigcapt bxwareki convbkmk endnotesj gentombow ifptex ifxptex ipaex japanese-otf japanese-otf-uptex jlreq jsclasses lshort-japanese luatexja mendex-doc morisawa pbibtex-base platex platex-tools platexcheat plautopatch ptex ptex-base ptex-fontmaps ptex-fonts ptex-manual ptex2pdf pxbase pxchfon pxcjkcat pxjahyper pxjodel pxrubrica pxufont uplatex uptex uptex-base uptex-fonts wadalab zxjafbfont zxjatype collection-langjapanese
"
TEXLIVE_MODULE_DOC_CONTENTS="ascmac.doc babel-japanese.doc bxbase.doc bxcjkjatype.doc bxjaholiday.doc bxjalipsum.doc bxjaprnind.doc bxjscls.doc bxorigcapt.doc bxwareki.doc convbkmk.doc endnotesj.doc gentombow.doc ifptex.doc ifxptex.doc ipaex.doc japanese-otf.doc japanese-otf-uptex.doc jlreq.doc jsclasses.doc lshort-japanese.doc luatexja.doc mendex-doc.doc morisawa.doc pbibtex-base.doc platex.doc platex-tools.doc platexcheat.doc plautopatch.doc ptex.doc ptex-base.doc ptex-fontmaps.doc ptex-fonts.doc ptex-manual.doc ptex2pdf.doc pxbase.doc pxchfon.doc pxcjkcat.doc pxjahyper.doc pxjodel.doc pxrubrica.doc pxufont.doc uplatex.doc uptex.doc uptex-base.doc uptex-fonts.doc wadalab.doc zxjafbfont.doc zxjatype.doc "
TEXLIVE_MODULE_SRC_CONTENTS="ascmac.source babel-japanese.source bxjscls.source japanese-otf.source japanese-otf-uptex.source jsclasses.source luatexja.source mendex-doc.source morisawa.source platex.source ptex-base.source ptex-fontmaps.source ptex-manual.source pxrubrica.source uplatex.source uptex-base.source "
inherit  texlive-module
DESCRIPTION="TeXLive Japanese"

LICENSE=" BSD BSD-2 GPL-1 GPL-2 GPL-3 LPPL-1.3 MIT public-domain TeX TeX-other-free "
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-langcjk-2019
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
