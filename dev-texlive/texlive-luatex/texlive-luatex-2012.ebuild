# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-luatex/texlive-luatex-2012.ebuild,v 1.3 2013/02/18 11:17:28 aballier Exp $

EAPI="4"

TEXLIVE_MODULE_CONTENTS="checkcites chickenize interpreter lua-visual-debug luabibentry luacode luaindex luainputenc lualatex-doc lualatex-math lualibs luamplib luaotfload luapersian luasseq luatexbase luatextra showhyphens collection-luatex
"
TEXLIVE_MODULE_DOC_CONTENTS="checkcites.doc chickenize.doc interpreter.doc lua-visual-debug.doc luabibentry.doc luacode.doc luaindex.doc luainputenc.doc lualatex-doc.doc lualatex-math.doc lualibs.doc luamplib.doc luaotfload.doc luapersian.doc luasseq.doc luatexbase.doc luatextra.doc showhyphens.doc "
TEXLIVE_MODULE_SRC_CONTENTS="chickenize.source luabibentry.source luacode.source luaindex.source luainputenc.source lualatex-doc.source lualatex-math.source lualibs.source luamplib.source luaotfload.source luasseq.source luatexbase.source luatextra.source "
inherit  texlive-module
DESCRIPTION="TeXLive LuaTeX packages"

LICENSE="GPL-2 FDL-1.1 LPPL-1.3 public-domain TeX-other-free"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2012
>=dev-tex/luatex-0.45

"
RDEPEND="${DEPEND}
	dev-texlive/texlive-xetex
	"
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/luaotfload/mkluatexfontdb.lua
	texmf-dist/scripts/checkcites/checkcites.lua
"
