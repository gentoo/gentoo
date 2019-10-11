# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="German and Swiss-German"
ASPELL_VERSION=6

inherit aspell-dict-r1

MY_P=aspell6-de-20030222-1

SRC_URI="mirror://gnu/aspell/dict/de/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

S=${WORKDIR}/${MY_P}
