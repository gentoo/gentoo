# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Dictionary files for the Migemo and C/Migemo"
HOMEPAGE="https://skk-dev.github.io/dict/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~hattya/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="unicode"

src_configure() {
	if use unicode; then
		iconv -f euc-jp -t utf-8 ${PN} >"${T}"/${PN} || die
	else
		cp ${PN} "${T}"/ || die
	fi
}

src_install() {
	insinto /usr/share/${PN%-*}
	doins "${T}"/${PN}
}
