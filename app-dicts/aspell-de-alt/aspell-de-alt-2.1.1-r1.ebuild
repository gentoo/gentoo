# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ASPELL_LANG="German (traditional orthography)"
ASPELL_VERSION=6
inherit aspell-dict-r1

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86"

PATCHES=( "${FILESDIR}/${P}-dict-name.patch" )

src_install() {
	aspell-dict-r1_src_install

	newdoc doc/README README.hk
	dodoc doc/README.bj
}
