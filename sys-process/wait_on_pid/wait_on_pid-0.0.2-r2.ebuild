# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

DESCRIPTION="Small utility to wait for an arbitrary process to exit"
HOMEPAGE="https://dev.gentoo.org/~zzam/wait_on_pid/"
SRC_URI="mirror://gentoo/${P}.tar.bz2 https://dev.gentoo.org/~zzam/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv x86"

src_prepare() {
	default
	tc-export CC
}

src_install() {
	default
	dobin wait_on_pid
}
