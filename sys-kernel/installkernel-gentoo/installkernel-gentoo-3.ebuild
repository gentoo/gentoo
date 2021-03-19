# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gentoo fork of installkernel script from debianutils"
HOMEPAGE="https://github.com/mgorny/installkernel-gentoo"
SRC_URI="https://github.com/mgorny/installkernel-gentoo/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x86-linux"

RDEPEND="
	>=sys-apps/debianutils-4.9-r1
	!<sys-apps/debianutils-4.9-r1[installkernel(+)]
	!sys-kernel/installkernel-systemd-boot"

src_install() {
	into /
	dosbin installkernel
	doman installkernel.8
	keepdir /etc/kernel/postinst.d
}

pkg_postinst() {
	if has 1 ${REPLACING_VERSIONS}; then
		ewarn "In v2, the initramfs filename has changed to initramfs*.img, to match"
		ewarn "the default names used by dracut and genkernel-4.  If your bootloader"
		ewarn "config uses the verbatim filename, please update it."
	fi
}
