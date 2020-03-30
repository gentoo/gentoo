# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Standard kernel module utilities for linux-2.4 and older"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/kernel/modutils/"
SRC_URI="https://www.kernel.org/pub/linux/utils/kernel/${PN}/v2.4/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 m68k ~mips ppc ppc64 ~riscv s390 sparc x86"

RDEPEND="!sys-apps/module-init-tools
	!sys-apps/kmod"

PATCHES=(
	"${FILESDIR}"/${P}-gcc.patch
	"${FILESDIR}"/${P}-flex.patch
	"${FILESDIR}"/${P}-no-nested-function.patch
)

src_configure() {
	econf \
		--prefix=/ \
		--disable-strip \
		--enable-insmod-static \
		--disable-zlib
}

src_install() {
	einstall prefix="${D}"
	rm -r "${ED}"/usr/share/man/man2 || die
	dodoc CREDITS ChangeLog NEWS README TODO
}
