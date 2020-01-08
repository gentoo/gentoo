# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="Polish"
ASPELL_VERSION=6

inherit versionator aspell-dict-r1

MY_P="${PN/aspell/aspell6}-$(replace_version_separator 2 _ $(replace_version_separator 3 -))"

HOMEPAGE="http://www.sjp.pl/slownik/"
SRC_URI="http://www.sjp.pl/slownik/ort/sjp-${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
