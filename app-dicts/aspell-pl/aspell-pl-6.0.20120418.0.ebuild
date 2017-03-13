# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

ASPELL_LANG="Polish"
ASPOSTFIX="6"
inherit versionator aspell-dict

HOMEPAGE="http://www.sjp.pl/slownik/"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

FILENAME="${PN/aspell/aspell6}-$(replace_version_separator 2 _ $(replace_version_separator 3 -))"
SRC_URI="http://www.sjp.pl/slownik/ort/sjp-${FILENAME}.tar.bz2"
S="${WORKDIR}/${FILENAME}"
