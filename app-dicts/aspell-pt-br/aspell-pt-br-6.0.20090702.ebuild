# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

ASPELL_LANG="Brazilian Portuguese"
ASPOSTFIX=6

inherit aspell-dict

FILENAME=aspell6-pt_BR-20090702-0
SRC_URI="mirror://gnu/aspell/dict/pt_BR/${FILENAME}.tar.bz2"

LICENSE="LGPL-2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

S=${WORKDIR}/${FILENAME}

# Contains a conflict
RDEPEND="!<app-dicts/aspell-pt-0.50.2-r1"
