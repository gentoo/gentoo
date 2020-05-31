# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="armtex babel-albanian babel-bosnian babel-breton babel-croatian babel-danish babel-dutch babel-estonian babel-finnish babel-friulan babel-hungarian babel-icelandic babel-irish babel-kurmanji babel-latin babel-latvian babel-macedonian babel-norsk babel-occitan babel-piedmontese babel-romanian babel-romansh babel-samin babel-scottish babel-slovenian babel-swedish babel-turkish babel-welsh finbib gloss-occitan hrlatex hulipsum hyphen-croatian hyphen-danish hyphen-dutch hyphen-estonian hyphen-finnish hyphen-friulan hyphen-hungarian hyphen-icelandic hyphen-irish hyphen-kurmanji hyphen-latin hyphen-latvian hyphen-lithuanian hyphen-macedonian hyphen-norwegian hyphen-occitan hyphen-piedmontese hyphen-romanian hyphen-romansh hyphen-slovenian hyphen-swedish hyphen-turkish hyphen-uppersorbian hyphen-welsh lithuanian lshort-dutch lshort-estonian lshort-finnish lshort-slovenian lshort-turkish nevelok swebib turkmen collection-langeuropean
"
TEXLIVE_MODULE_DOC_CONTENTS="armtex.doc babel-albanian.doc babel-bosnian.doc babel-breton.doc babel-croatian.doc babel-danish.doc babel-dutch.doc babel-estonian.doc babel-finnish.doc babel-friulan.doc babel-hungarian.doc babel-icelandic.doc babel-irish.doc babel-kurmanji.doc babel-latin.doc babel-latvian.doc babel-macedonian.doc babel-norsk.doc babel-occitan.doc babel-piedmontese.doc babel-romanian.doc babel-romansh.doc babel-samin.doc babel-scottish.doc babel-slovenian.doc babel-swedish.doc babel-turkish.doc babel-welsh.doc gloss-occitan.doc hrlatex.doc hulipsum.doc hyphen-hungarian.doc lithuanian.doc lshort-dutch.doc lshort-estonian.doc lshort-finnish.doc lshort-slovenian.doc lshort-turkish.doc nevelok.doc swebib.doc turkmen.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-albanian.source babel-bosnian.source babel-breton.source babel-croatian.source babel-danish.source babel-dutch.source babel-estonian.source babel-finnish.source babel-friulan.source babel-icelandic.source babel-irish.source babel-kurmanji.source babel-latin.source babel-latvian.source babel-macedonian.source babel-norsk.source babel-occitan.source babel-piedmontese.source babel-romanian.source babel-romansh.source babel-samin.source babel-scottish.source babel-slovenian.source babel-swedish.source babel-turkish.source babel-welsh.source gloss-occitan.source hrlatex.source hulipsum.source hyphen-turkish.source nevelok.source turkmen.source "
inherit  texlive-module
DESCRIPTION="TeXLive Other European languages"

LICENSE=" GPL-1 GPL-2 LPPL-1.2 LPPL-1.3 LPPL-1.3c public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
"
RDEPEND="${DEPEND} "
