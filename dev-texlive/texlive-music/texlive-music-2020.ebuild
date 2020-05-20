# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="abc autosp bagpipe chordbars chordbox ddphonism figbas gchords gregoriotex gtrcrd guitar guitarchordschemes guitartabs harmony leadsheets latex4musicians lilyglyphs lyluatex m-tx musicography musixguit musixtex musixtex-fonts musixtnt octave piano pmx pmxchords songbook songs xpiano collection-music
"
TEXLIVE_MODULE_DOC_CONTENTS="abc.doc autosp.doc bagpipe.doc chordbars.doc chordbox.doc ddphonism.doc figbas.doc gchords.doc gregoriotex.doc gtrcrd.doc guitar.doc guitarchordschemes.doc guitartabs.doc harmony.doc leadsheets.doc latex4musicians.doc lilyglyphs.doc lyluatex.doc m-tx.doc musicography.doc musixguit.doc musixtex.doc musixtex-fonts.doc musixtnt.doc octave.doc piano.doc pmx.doc pmxchords.doc songbook.doc songs.doc xpiano.doc "
TEXLIVE_MODULE_SRC_CONTENTS="abc.source guitar.source lilyglyphs.source musixtex.source songbook.source songs.source xpiano.source "
inherit  texlive-module
DESCRIPTION="TeXLive Music packages"

LICENSE=" FDL-1.1 GPL-1 GPL-2 GPL-2+ "
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2020
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/musixtex/musixflx.lua
	texmf-dist/scripts/musixtex/musixtex.lua
	texmf-dist/scripts/m-tx/m-tx.lua
	texmf-dist/scripts/pmxchords/pmxchords.lua
	texmf-dist/scripts/lilyglyphs/lily-glyph-commands.py
	texmf-dist/scripts/lilyglyphs/lily-image-commands.py
	texmf-dist/scripts/lilyglyphs/lily-rebuild-pdfs.py
"
