# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ASPELL_LANG="Irish"
ASPELL_VERSION=5
MY_P="${PN/aspell/aspell${ASPELL_VERSION}}-${PV%.*}-${PV##*.}"

inherit aspell-dict-r1

HOMEPAGE="
	https://cadhan.com/gaelspell/
	https://github.com/kscanne/gaelspell
"
SRC_URI="https://github.com/kscanne/gaelspell/releases/download/v${PV%.*}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
