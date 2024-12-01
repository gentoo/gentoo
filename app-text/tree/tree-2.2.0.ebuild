# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Lists directories recursively, and produces an indented listing of files"
HOMEPAGE="https://mama.indstate.edu/users/ice/tree/ https://gitlab.com/OldManProgrammer/unix-tree"
SRC_URI="https://gitlab.com/OldManProgrammer/unix-${PN}/-/archive/${PV}/unix-${P}.tar.bz2"
S="${WORKDIR}/unix-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

src_configure() {
	tc-export CC
}

src_install() {
	dobin tree
	doman doc/tree*.1
	einstalldocs
}
