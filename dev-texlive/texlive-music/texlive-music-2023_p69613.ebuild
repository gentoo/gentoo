# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

TEXLIVE_MODULE_CONTENTS="
	collection-music.r69613
	abc.r41157
	bagpipe.r34393
	chordbars.r49569
	chordbox.r51000
	ddphonism.r52009
	figbas.r28943
	gchords.r29803
	gregoriotex.r58331
	gtrcrd.r32484
	guitar.r32258
	guitarchordschemes.r54512
	guitartabs.r48102
	harmony.r15878
	leadsheets.r61504
	lilyglyphs.r56473
	lyluatex.r66880
	musical.r54758
	musicography.r68220
	musixguit.r21649
	musixtex.r69742
	musixtex-fonts.r65517
	musixtnt.r69742
	octave.r66115
	piano.r21574
	pmxchords.r39249
	recorder-fingering.r68595
	songbook.r18136
	songproj.r66704
	songs.r51494
	undar-digitacion.r69742
	xpiano.r61719
"
TEXLIVE_MODULE_DOC_CONTENTS="
	abc.doc.r41157
	bagpipe.doc.r34393
	chordbars.doc.r49569
	chordbox.doc.r51000
	ddphonism.doc.r52009
	figbas.doc.r28943
	gchords.doc.r29803
	gregoriotex.doc.r58331
	gtrcrd.doc.r32484
	guitar.doc.r32258
	guitarchordschemes.doc.r54512
	guitartabs.doc.r48102
	harmony.doc.r15878
	latex4musicians.doc.r49759
	leadsheets.doc.r61504
	lilyglyphs.doc.r56473
	lyluatex.doc.r66880
	musical.doc.r54758
	musicography.doc.r68220
	musixguit.doc.r21649
	musixtex.doc.r69742
	musixtex-fonts.doc.r65517
	musixtnt.doc.r69742
	octave.doc.r66115
	piano.doc.r21574
	pmxchords.doc.r39249
	recorder-fingering.doc.r68595
	songbook.doc.r18136
	songproj.doc.r66704
	songs.doc.r51494
	undar-digitacion.doc.r69742
	xpiano.doc.r61719
"
TEXLIVE_MODULE_SRC_CONTENTS="
	abc.source.r41157
	gregoriotex.source.r58331
	guitar.source.r32258
	lilyglyphs.source.r56473
	musixtex.source.r69742
	songbook.source.r18136
	songproj.source.r66704
	songs.source.r51494
	undar-digitacion.source.r69742
	xpiano.source.r61719
"

inherit texlive-module

DESCRIPTION="TeXLive Music packages"

LICENSE="BSD CC-BY-SA-4.0 FDL-1.1 GPL-1 GPL-2 GPL-2+ GPL-3 GPL-3+ LGPL-2.1 LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-latex-2023
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/lilyglyphs/lily-glyph-commands.py
	texmf-dist/scripts/lilyglyphs/lily-image-commands.py
	texmf-dist/scripts/lilyglyphs/lily-rebuild-pdfs.py
	texmf-dist/scripts/musixtex/musixflx.lua
	texmf-dist/scripts/musixtex/musixtex.lua
	texmf-dist/scripts/pmxchords/pmxchords.lua
"
