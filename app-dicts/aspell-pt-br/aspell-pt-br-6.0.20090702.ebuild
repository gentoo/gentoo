# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="Brazilian Portuguese"
ASPELL_VERSION=6

inherit aspell-dict-r1

MY_P="aspell6-pt_BR-20090702-0"

SRC_URI="mirror://gnu/aspell/dict/pt_BR/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

# Contains a conflict
RDEPEND="!<app-dicts/aspell-pt-0.50.2-r1"
