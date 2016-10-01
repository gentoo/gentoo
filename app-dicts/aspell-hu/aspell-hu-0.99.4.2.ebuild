# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

ASPELL_LANG="Hungarian"
ASPOSTFIX="6"

inherit aspell-dict

LICENSE="GPL-2"

KEYWORDS="alpha ~amd64 ~arm hppa ~ia64 ~m68k ~ppc ppc64 ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

FILENAME="aspell6-hu-0.99.4.2-0"
SRC_URI="mirror://gnu/aspell/dict/hu/${FILENAME}.tar.bz2"

S="${WORKDIR}/${FILENAME}"
