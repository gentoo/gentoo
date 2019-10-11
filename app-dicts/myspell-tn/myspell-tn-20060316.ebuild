# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

MYSPELL_SPELLING_DICTIONARIES=(
"tn,ZA,tn_ZA,Setswana (Africa),tn_ZA.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Setswana dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86"
