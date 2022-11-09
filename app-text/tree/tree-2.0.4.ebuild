# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs flag-o-matic bash-completion-r1

DESCRIPTION="Lists directories recursively, and produces an indented listing of files"
HOMEPAGE="https://mama.indstate.edu/users/ice/tree/ https://gitlab.com/OldManProgrammer/unix-tree"
SRC_URI="https://gitlab.com/OldManProgrammer/unix-${PN}/-/archive/${PV}/unix-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

S=${WORKDIR}/unix-${P}

RDEPEND=""
DEPEND=""

src_prepare() {
	if use !elibc_glibc ; then
		# 433972, also previously done only for elibc_uclibc
		sed -i -e '/^OBJS=/s/$/ strverscmp.o/' Makefile || die
	fi
	default
}

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
	newbashcomp "${FILESDIR}"/${PN}.bashcomp ${PN}
}
