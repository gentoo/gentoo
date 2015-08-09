# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MYSPELL_SPELLING_DICTIONARIES=(
"ru,RU,ru_RU,Russian (Russia),ru_RU.zip"
"ru,RU,ru_RU_ie,Russian_ye (Russia),ru_RU_ye.zip"
"ru,RU,ru_RU_yo,Russian_yo (Russia),ru_RU_yo.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"ru,RU,hyph_ru_RU,Russian (Russia),hyph_ru_RU.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Russian dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1 myspell-ru_RU-ALexanderLebedev"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~amd64-linux ~x86-fbsd"
