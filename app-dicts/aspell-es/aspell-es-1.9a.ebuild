# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-es/aspell-es-1.9a.ebuild,v 1.10 2012/05/17 19:55:01 aballier Exp $

ASPELL_LANG="Spanish"
ASPOSTFIX="6"

inherit aspell-dict

MY_P="${P/aspell/aspell6}-1"
S=${WORKDIR}/${MY_P}
SRC_URI="mirror://gnu/aspell/dict/${SPELLANG}/${MY_P}.tar.bz2"

LICENSE="GPL-2"

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""
