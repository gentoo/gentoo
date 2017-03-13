# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

ASPELL_LANG="French"
ASPOSTFIX="6"

# This is a hack to allow for using the French 0.50 dictionary until I have
# the time to do this properly. Do not stabilise this.

inherit aspell-dict

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~ppc-macos"

FILENAME="aspell-fr-0.50-3"
SRC_URI="mirror://gnu/aspell/dict/fr/${FILENAME}.tar.bz2"
IUSE=""

S=${WORKDIR}/${FILENAME}
