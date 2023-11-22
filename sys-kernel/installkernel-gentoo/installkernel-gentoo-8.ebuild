# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gentoo fork of installkernel script from debianutils"
HOMEPAGE="https://github.com/projg2/installkernel-gentoo"
SRC_URI="https://github.com/projg2/installkernel-gentoo/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x86-linux"
IUSE="dracut grub uki ukify"

RDEPEND="
	>=sys-apps/debianutils-4.9-r1
	!<sys-apps/debianutils-4.9-r1[installkernel(+)]
	!sys-kernel/installkernel-systemd
"

src_install() {
	into /
	dosbin installkernel
	doman installkernel.8
	keepdir /etc/kernel/postinst.d
	keepdir /etc/kernel/preinst.d

	if use dracut; then
		exeinto /etc/kernel/preinst.d
		doexe hooks/50-dracut.install
	fi

	if use grub; then
		exeinto /etc/kernel/postinst.d
		doexe hooks/91-grub-mkconfig.install
	fi

	if use uki; then
		exeinto /etc/kernel/postinst.d
		doexe hooks/90-uki-copy.install
	fi

	if use ukify; then
		exeinto /etc/kernel/preinst.d
		doexe hooks/60-ukify.install
	fi
}

pkg_postinst() {
	if has 1 ${REPLACING_VERSIONS}; then
		ewarn "In v2, the initramfs filename has changed to initramfs*.img, to match"
		ewarn "the default names used by dracut and genkernel-4.  If your bootloader"
		ewarn "config uses the verbatim filename, please update it."
	fi
}
