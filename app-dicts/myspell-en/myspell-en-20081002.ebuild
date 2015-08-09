# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MYSPELL_SPELLING_DICTIONARIES=(
"en,AU,en_AU,English (Australian),en_AU.zip"
"en,GB,en_GB,English (United Kingdom),en_GB.zip"
"en,US,en_US,English (United States),en_US.zip"
"en,CA,en_CA,English (Canada),en_CA.zip"
"en,NZ,en_NZ,English (New Zealand),en_NZ.zip"
"en,ZA,en_ZA,English (South Africa),en_ZA.zip"
"en,GB,en_GB-oed,English (OED English)),en_GB-oed.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"en,US,hyph_en_GB,English (United States),hyph_en_GB.zip"
"en,GB,hyph_en_GB,English (United Kingdom),hyph_en_GB.zip"
"en,CA,hyph_en_GB,English (Canada),hyph_en_GB.zip"
"en,AU,hyph_en_GB,English (Australian),hyph_en_GB.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
"en,US,th_en_US_v2,English (United States),thes_en_US_v2.zip"
"en,GB,th_en_US_v2,English (United Kingdom),thes_en_US_v2.zip"
)

inherit myspell

DESCRIPTION="English dictionaries for myspell/hunspell"
LICENSE="GPL-2 LGPL-2.1 Princeton myspell-en_CA-KevinAtkinson"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""
