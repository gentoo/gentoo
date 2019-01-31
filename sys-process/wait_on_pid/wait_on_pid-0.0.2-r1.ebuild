# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="small utility to wait for an arbitrary process to exit"
HOMEPAGE="https://dev.gentoo.org/~zzam/wait_on_pid/"
SRC_URI="mirror://gentoo/$P.tar.bz2 https://dev.gentoo.org/~zzam/wait_on_pid/$P.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	default
	tc-export CC
}

src_install() {
	default
	dobin wait_on_pid
}
