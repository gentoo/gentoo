# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tool for managing multiple xterms simultaneously"
HOMEPAGE="https://github.com/walterdejong/pconsole"
SRC_URI="http://www.xs4all.nl/~walterj/pconsole/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

PATCHES=( "${FILESDIR}"/${P}-exit-warn.patch )

src_compile() {
	emake LFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)"
}

src_install() {
	dobin pconsole
	fperms 4110 /usr/bin/pconsole
	dodoc ChangeLog README.pconsole public_html/pconsole.html
}

pkg_postinst() {
	ewarn "Warning:"
	ewarn "pconsole installed with suid root!"
}
