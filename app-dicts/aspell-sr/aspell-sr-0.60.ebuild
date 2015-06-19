# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/aspell-sr/aspell-sr-0.60.ebuild,v 1.19 2012/05/17 20:09:33 aballier Exp $

ASPELL_LANG="Serbian"
ASPOSTFIX="6"

inherit aspell-dict

LICENSE="GPL-2"

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

FILENAME="aspell6-sr-0.02"
SRC_URI="http://srpski.org/aspell/${FILENAME}.tar.bz2"
S="${WORKDIR}/${FILENAME}"
