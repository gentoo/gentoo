# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-music.r76267
	abc.r41157
	bagpipe.r34393
	chordbars.r70392
	chordbox.r51000
	ddphonism.r75201
	figbas.r28943
	fretplot.r78741
	gchords.r79618
	gregoriotex.r79618
	gtrcrd.r32484
	guitar.r32258
	guitarchordschemes.r54512
	guitartabs.r48102
	harmony.r72045
	leadsheets.r61504
	liederbuch.r76924
	lilyglyphs.r56473
	lyluatex.r79159
	musical.r54758
	musicography.r77682
	musixguit.r21649
	musixtex.r79618
	musixtex-fonts.r65517
	musixtnt.r69742
	octave.r76790
	piano.r79662
	pmxchords.r73868
	recorder-fingering.r76924
	songbook.r79618
	songproj.r76924
	songs.r79618
	undar-digitacion.r69742
	xpiano.r77682
"
TEXLIVE_MODULE_SRC_CONTENTS="
	abc.doc.r41157
	bagpipe.doc.r34393
	chordbars.doc.r70392
	chordbox.doc.r51000
	ddphonism.doc.r75201
	figbas.doc.r28943
	fretplot.doc.r78741
	gchords.doc.r79618
	gregoriotex.doc.r79618
	gtrcrd.doc.r32484
	guitar.doc.r32258
	guitarchordschemes.doc.r54512
	guitartabs.doc.r48102
	harmony.doc.r72045
	latex4musicians.doc.r49759
	leadsheets.doc.r61504
	liederbuch.doc.r76924
	lilyglyphs.doc.r56473
	lyluatex.doc.r79159
	musical.doc.r54758
	musicography.doc.r77682
	musixguit.doc.r21649
	musixtex.doc.r79618
	musixtex-fonts.doc.r65517
	musixtnt.doc.r69742
	octave.doc.r76790
	piano.doc.r79662
	pmxchords.doc.r73868
	recorder-fingering.doc.r76924
	songbook.doc.r79618
	songproj.doc.r76924
	songs.doc.r79618
	undar-digitacion.doc.r69742
	xpiano.doc.r77682
"
TEXLIVE_MODULE_DOC_CONTENTS="
	abc.source.r41157
	gregoriotex.source.r79618
	guitar.source.r32258
	lilyglyphs.source.r56473
	musixtex.source.r79618
	songbook.source.r79618
	songproj.source.r76924
	songs.source.r79618
	undar-digitacion.source.r69742
	xpiano.source.r77682
"

inherit texlive-module

DESCRIPTION="TeXLive Music packages"

LICENSE="BSD CC-BY-SA-4.0 FDL-1.1+ GPL-1+ GPL-2 GPL-2+ GPL-3 LGPL-2.1 LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-latex-2026
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
