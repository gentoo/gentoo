# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

MYSPELL_SPELLING_DICTIONARIES=(
"sw,KE,sw_KE,Kiswahili (Africa),sw_KE.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Kiswahili dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
