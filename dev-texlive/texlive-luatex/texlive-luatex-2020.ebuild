# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="addliga auto-pst-pdf-lua barracuda bezierplot checkcites chickenize combofont cstypo ctablestack emoji enigma interpreter kanaparser lua-uca lua-ul lua-visual-debug luacode luacolor luahyphenrules luaimageembed luaindex luainputenc luaintro lualatex-doc lualatex-math lualatex-truncate lualibs luamplib luaotfload luapackageloader luarandom luatex85 luatexbase luatexko luatextra luavlna luaxml nodetree odsfile optex pdfarticle placeat plantuml selnolig spelling typewriter collection-luatex
"
TEXLIVE_MODULE_DOC_CONTENTS="addliga.doc auto-pst-pdf-lua.doc barracuda.doc bezierplot.doc checkcites.doc chickenize.doc combofont.doc cstypo.doc ctablestack.doc emoji.doc enigma.doc interpreter.doc kanaparser.doc lua-uca.doc lua-ul.doc lua-visual-debug.doc luacode.doc luacolor.doc luahyphenrules.doc luaimageembed.doc luaindex.doc luainputenc.doc luaintro.doc lualatex-doc.doc lualatex-math.doc lualatex-truncate.doc lualibs.doc luamplib.doc luaotfload.doc luapackageloader.doc luarandom.doc luatex85.doc luatexbase.doc luatexko.doc luatextra.doc luavlna.doc luaxml.doc nodetree.doc odsfile.doc optex.doc pdfarticle.doc placeat.doc plantuml.doc selnolig.doc spelling.doc typewriter.doc "
TEXLIVE_MODULE_SRC_CONTENTS="chickenize.source ctablestack.source lua-uca.source lua-ul.source luacode.source luacolor.source luaindex.source luainputenc.source lualatex-doc.source lualatex-math.source lualatex-truncate.source lualibs.source luamplib.source luaotfload.source luatex85.source luatexbase.source luatextra.source nodetree.source placeat.source "
inherit  texlive-module
DESCRIPTION="TeXLive LuaTeX packages"

LICENSE=" BSD FDL-1.1 GPL-2 LPPL-1.3 LPPL-1.3c MIT public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
"
RDEPEND="${DEPEND} dev-texlive/texlive-latexrecommended
"
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/luaotfload/luaotfload-tool.lua
	texmf-dist/scripts/checkcites/checkcites.lua
	"

TEXLIVE_MODULE_BINLINKS="
	luaotfload-tool:mkluatexfontdb
	"
