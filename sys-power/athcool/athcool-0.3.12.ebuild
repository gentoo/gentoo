# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="small utility to toggle Powersaving mode for AMD Athlon/Duron processors"
HOMEPAGE="http://members.jcom.home.ne.jp/jacobi/linux/softwares.html#athcool"
SRC_URI="http://members.jcom.home.ne.jp/jacobi/linux/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86"

DEPEND="sys-apps/pciutils"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	default
	doinitd "${FILESDIR}"/athcool
}

pkg_postinst() {
	ewarn "WARNING: Depending on your motherboard and/or hardware components,"
	ewarn "enabling powersaving mode may cause:"
	ewarn " * noisy or distorted sound playback"
	ewarn " * a slowdown in harddisk performance"
	ewarn " * system locks or unpredictable behavior"
	ewarn " * file system corruption"
	ewarn "If you met those problems, you should not use athcool.  Please use"
	ewarn "athcool AT YOUR OWN RISK!"
}
