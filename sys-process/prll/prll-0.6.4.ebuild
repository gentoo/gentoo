# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs readme.gentoo-r1

DESCRIPTION="Utility for parallelizing execution of shell functions"
HOMEPAGE="https://github.com/exzombie/prll"
SRC_URI="https://github.com/exzombie/prll/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

DOC_CONTENTS="
You must source the prll.sh file located\nin /etc/profile.d to be able to use prll:\n
$ source /etc/profile.d/prll.sh
"

src_prepare() {
	default
	sed \
		-e '/then sh/d' \
		-e '/then zsh/d' \
		-e '/then dash/d' \
		-i tests/Makefile || die
	tc-export CC
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
	einstalldocs
	readme.gentoo_create_doc
	rm -rf "${D}/usr/share/doc/prll" || die
}

pkg_postinst() {
	readme.gentoo_print_elog
}
