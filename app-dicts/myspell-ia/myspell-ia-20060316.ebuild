# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-ia/myspell-ia-20060316.ebuild,v 1.17 2012/05/17 18:18:48 aballier Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"ia,ANY,ia,Interlingua (ANY locale),ia_ANY.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"ia,ANY,hyph_ia,Interlingua (ANY locale),hyph_ia_ANY.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Interlingua dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
