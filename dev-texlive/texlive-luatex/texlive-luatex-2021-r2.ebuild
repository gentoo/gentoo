# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="addliga auto-pst-pdf-lua barracuda bezierplot checkcites chickenize chinese-jfm cloze combofont cstypo ctablestack ekdosis emoji emojicite enigma innerscript interpreter kanaparser lua-typo lua-uca lua-uni-algos lua-ul lua-visual-debug luacode luacolor luahyphenrules luaimageembed luaindex luainputenc luaintro luakeys lualatex-doc lualatex-math lualatex-truncate lualibs luamplib luaotfload luapackageloader luaprogtable luarandom luatex85 luatexbase luatexko luatextra luavlna luaxml newpax nodetree odsfile optex pdfarticle placeat plantuml selnolig spelling stricttex typewriter uninormalize collection-luatex
"
TEXLIVE_MODULE_DOC_CONTENTS="addliga.doc auto-pst-pdf-lua.doc barracuda.doc bezierplot.doc checkcites.doc chickenize.doc chinese-jfm.doc cloze.doc combofont.doc cstypo.doc ctablestack.doc ekdosis.doc emoji.doc emojicite.doc enigma.doc innerscript.doc interpreter.doc kanaparser.doc lua-typo.doc lua-uca.doc lua-uni-algos.doc lua-ul.doc lua-visual-debug.doc luacode.doc luacolor.doc luahyphenrules.doc luaimageembed.doc luaindex.doc luainputenc.doc luaintro.doc luakeys.doc lualatex-doc.doc lualatex-math.doc lualatex-truncate.doc lualibs.doc luamplib.doc luaotfload.doc luapackageloader.doc luaprogtable.doc luarandom.doc luatex85.doc luatexbase.doc luatexko.doc luatextra.doc luavlna.doc luaxml.doc newpax.doc nodetree.doc odsfile.doc optex.doc pdfarticle.doc placeat.doc plantuml.doc selnolig.doc spelling.doc stricttex.doc typewriter.doc uninormalize.doc "
TEXLIVE_MODULE_SRC_CONTENTS="chickenize.source cloze.source ctablestack.source ekdosis.source innerscript.source lua-typo.source lua-ul.source luacode.source luacolor.source luaindex.source luainputenc.source lualatex-doc.source lualatex-math.source lualatex-truncate.source lualibs.source luamplib.source luaotfload.source luatex85.source luatexbase.source luatextra.source newpax.source nodetree.source placeat.source "
inherit prefix texlive-module
DESCRIPTION="TeXLive LuaTeX packages"

LICENSE=" BSD FDL-1.1 GPL-2 GPL-3+ LPPL-1.3 LPPL-1.3c MIT public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND="!~dev-texlive/texlive-latexextra-2020
	>=dev-texlive/texlive-basic-2021
"
RDEPEND="
	${DEPEND}
	dev-texlive/texlive-latexrecommended
	dev-texlive/texlive-fontsrecommended
"
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/luaotfload/luaotfload-tool.lua
	texmf-dist/scripts/checkcites/checkcites.lua
	"

TEXLIVE_MODULE_BINLINKS="
	luaotfload-tool:mkluatexfontdb
	"

src_prepare(){
	default
	hprefixify texmf-dist/tex/luatex/luaotfload/luaotfload-database.lua
}
