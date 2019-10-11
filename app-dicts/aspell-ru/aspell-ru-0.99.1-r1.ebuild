# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="Russian"
ASPELL_VERSION=6

inherit aspell-dict-r1

# very strange filename not supported by the gentoo naming scheme
MY_P="aspell6-ru-0.99f7-1"

SRC_URI="mirror://gnu/aspell/dict/ru/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	einfo "Setting default dictionary to ru-yeyo"
	cp -v ru-yeyo.multi ru.multi || die
}
