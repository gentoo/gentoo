# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Lists directories recursively, and produces an indented listing of files"
HOMEPAGE="https://oldmanprogrammer.net/source.php?dir=projects/tree https://gitlab.com/OldManProgrammer/unix-tree"
SRC_URI="https://gitlab.com/OldManProgrammer/unix-${PN}/-/archive/${PV}/unix-${P}.tar.bz2"
S="${WORKDIR}/unix-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

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
