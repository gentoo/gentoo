# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

ASPELL_LANG="Armenian"
ASPOSTFIX="6"

inherit aspell-dict

LICENSE="GPL-2"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ppc ppc64 sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

FILENAME=aspell6-hy-0.10.0-0
SRC_URI="mirror://gnu/aspell/dict/hy/${FILENAME}.tar.bz2"

S="${WORKDIR}/${FILENAME}"
