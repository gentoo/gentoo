# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="serial graphics adapter bios option rom for x86"
HOMEPAGE="https://code.google.com/p/sgabios/"
# downloaded from
# https://git.qemu.org/?p=sgabios.git;a=tree;h=a85446adb0e07ccd5211619a6f215bcfc3c5ab29;hb=23d474943dcd55d0550a3d20b3d30e9040a4f15b
SRC_URI="mirror://gentoo/${P}.tar.gz
	!binary? ( https://dev.gentoo.org/~tamiko/distfiles/${P}.tar.gz )
	binary? ( https://dev.gentoo.org/~tamiko/distfiles/${P}-bin.tar.xz )"
S="${WORKDIR}/sgabios-a85446a"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="+binary"
REQUIRED_USE="!amd64? ( !x86? ( binary ) )"

src_compile() {
	use binary && return

	tc-ld-disable-gold
	tc-export_build_env BUILD_CC
	emake -j1 \
		BUILD_CC="${BUILD_CC}" \
		BUILD_CFLAGS="${BUILD_CFLAGS}" \
		BUILD_LDFLAGS="${BUILD_LDFLAGS}" \
		BUILD_CPPFLAGS="${BUILD_CPPFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		AR="$(tc-getAR)" \
		OBJCOPY="$(tc-getOBJCOPY)"
}

src_install() {
	insinto /usr/share/sgabios
	doins sgabios.bin
}
