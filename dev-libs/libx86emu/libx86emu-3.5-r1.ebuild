# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A library for emulating x86"
HOMEPAGE="https://github.com/wfeldt/libx86emu"
SRC_URI="https://github.com/wfeldt/libx86emu/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 x86 ~amd64-linux ~x86-linux"

src_prepare() {
	default
	echo "${PV}" > VERSION || die
	rm -fr git2log || die
}

src_compile() {
	emake shared CC=$(tc-getCC) CFLAGS="${CFLAGS} -fPIC -Wall" LDFLAGS="${LDFLAGS}"
}

src_test() {
	emake test CC=$(tc-getCC) CFLAGS="${CFLAGS} -fPIC -Wall" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
	dodoc README.md
}
