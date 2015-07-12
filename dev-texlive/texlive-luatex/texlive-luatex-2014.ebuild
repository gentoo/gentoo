# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-luatex/texlive-luatex-2014.ebuild,v 1.2 2015/07/12 15:47:03 ago Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="checkcites chickenize enigma interpreter lua-check-hyphen lua-visual-debug lua2dox luabibentry luabidi luacode luaindex luainputenc luaintro lualatex-doc lualatex-math lualibs luamplib luaotfload luasseq luatexbase luatexko luatextra luatodonotes luaxml odsfile placeat selnolig showhyphens spelling collection-luatex
"
TEXLIVE_MODULE_DOC_CONTENTS="checkcites.doc chickenize.doc enigma.doc interpreter.doc lua-check-hyphen.doc lua-visual-debug.doc lua2dox.doc luabibentry.doc luabidi.doc luacode.doc luaindex.doc luainputenc.doc luaintro.doc lualatex-doc.doc lualatex-math.doc lualibs.doc luamplib.doc luaotfload.doc luasseq.doc luatexbase.doc luatexko.doc luatextra.doc luatodonotes.doc luaxml.doc odsfile.doc placeat.doc selnolig.doc showhyphens.doc spelling.doc "
TEXLIVE_MODULE_SRC_CONTENTS="chickenize.source luabibentry.source luacode.source luaindex.source luainputenc.source lualatex-doc.source lualatex-math.source lualibs.source luamplib.source luaotfload.source luasseq.source luatexbase.source luatextra.source luatodonotes.source placeat.source "
inherit  texlive-module
DESCRIPTION="TeXLive LuaTeX packages"

LICENSE=" BSD FDL-1.1 GPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2014
"
RDEPEND="${DEPEND} dev-texlive/texlive-xetex
"
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/luaotfload/luaotfload-tool.lua
	texmf-dist/scripts/checkcites/checkcites.lua
	texmf-dist/scripts/lua2dox/lua2dox_filter
	"

TEXLIVE_MODULE_BINLINKS="
	luaotfload-tool:mkluatexfontdb
	"
