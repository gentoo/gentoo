# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Lists directories recursively, and produces an indented listing of files"
HOMEPAGE="https://mama.indstate.edu/users/ice/tree/ https://gitlab.com/OldManProgrammer/unix-tree"
SRC_URI="https://gitlab.com/OldManProgrammer/unix-${PN}/-/archive/${PV}/unix-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

S=${WORKDIR}/unix-${P}

src_compile() {
	append-lfs-flags
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin tree
	doman doc/tree*.1
	einstalldocs
}
