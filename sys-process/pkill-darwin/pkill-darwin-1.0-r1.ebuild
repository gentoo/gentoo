# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="pgrep(1) and pkill(1) for Darwin"
HOMEPAGE="https://sourceforge.net/p/pkilldarwin/code/ci/default/tree/"
SRC_URI="https://dev.gentoo.org/~grobian/distfiles/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm64-macos ~x64-macos"

src_compile() {
	edo $(tc-getCC) ${CFLAGS} -o pkill ${LDFLAGS} pkill.c
	# don't link, such that the suid trick described below won't make people
	# suid their pkill too
	cp pkill pgrep || die
	ln -s pkill.1 pgrep.1 || die
}

src_install() {
	into /usr
	dobin pkill pgrep
	doman pkill.1 pgrep.1
}

pkg_postinst() {
	einfo "If you you want pgrep to be able to show and match on the arguments"
	einfo "of all processes, you will have to make pgrep suid root.  To do so"
	einfo "you have to perform the following steps:"
	einfo "  % sudo chown root ${EPREFIX}/usr/bin/pgrep"
	einfo "  % sudo chmod u+s ${EPREFIX}/usr/bin/pgrep"
}
