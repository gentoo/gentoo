# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="French"
ASPELL_VERSION=6

# This is a hack to allow for using the French 0.50 dictionary until I have
# the time to do this properly. Do not stabilise this.

inherit aspell-dict-r1

MY_P="aspell-fr-0.50-3"

SRC_URI="mirror://gnu/aspell/dict/fr/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-macos"
IUSE=""

S=${WORKDIR}/${MY_P}
