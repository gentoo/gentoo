# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Statically linked x86-64 binary of app-emulation/qemu, riscv64 emulator"

HOMEPAGE="http://www.qemu.org"
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${PN}-${PVR}.tar.xz"
LICENSE="GPL-2 LGPL-2 BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!app-emulation/qemu[qemu_user_targets_riscv64]"

QA_PREBUILT="*"

S=${WORKDIR}

src_install() {
	dobin qemu-riscv64
}
