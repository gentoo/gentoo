# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

MYSPELL_SPELLING_DICTIONARIES=(
"ga,IE,ga_IE,Irish (Ireland),ga_IE.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"ga,IE,hyph_ga_IE,Irish (Ireland),hyph_ga_IE.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Irish dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://lingucomponent.openoffice.org/ http://borel.slu.edu/ispell/"
IUSE=""

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
