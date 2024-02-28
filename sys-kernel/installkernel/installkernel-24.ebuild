# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gentoo fork of installkernel script from debianutils"
HOMEPAGE="
	https://github.com/projg2/installkernel-gentoo
	https://wiki.gentoo.org/wiki/Installkernel
"
SRC_URI="https://github.com/projg2/installkernel-gentoo/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-gentoo-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x86-linux"
IUSE="dracut grub systemd systemd-boot uki ukify"
REQUIRED_USE="systemd-boot? ( systemd )"

RDEPEND="
	!<=sys-kernel/installkernel-systemd-3
	dracut? ( >=sys-kernel/dracut-060_pre20240104-r1 )
	grub? ( sys-boot/grub )
	systemd? (
		|| (
			sys-apps/systemd[kernel-install(-)]
			sys-apps/systemd-utils[kernel-install(-)]
		)
	)
	systemd-boot? (
		|| (
			sys-apps/systemd[boot(-)]
			sys-apps/systemd-utils[boot(-)]
		)
	)
	ukify? (
		|| (
			sys-apps/systemd[ukify(-)]
			sys-apps/systemd-utils[ukify(-)]
		)
	)
	!=sys-apps/systemd-255.2-r1
	!=sys-apps/systemd-255.2-r0
	!~sys-apps/systemd-255.1
	!~sys-apps/systemd-255.0
	!=sys-apps/systemd-254.8-r0
	!=sys-apps/systemd-254.7-r0
	!~sys-apps/systemd-254.6
	!<=sys-apps/systemd-254.5-r1
" # Block against systemd that still installs dummy install.conf

src_install() {
	keepdir /etc/kernel/postinst.d
	keepdir /etc/kernel/preinst.d

	exeinto /etc/kernel/preinst.d
	use dracut && doexe hooks/50-dracut.install
	use ukify && doexe hooks/60-ukify.install

	exeinto /etc/kernel/postinst.d
	use uki && doexe hooks/90-uki-copy.install
	use grub && doexe hooks/91-grub-mkconfig.install

	exeinto /usr/lib/kernel/install.d
	doexe hooks/systemd/00-00machineid-directory.install
	doexe hooks/systemd/10-copy-prebuilt.install
	doexe hooks/systemd/90-compat.install
	use grub && doexe hooks/systemd/91-grub-mkconfig.install

	if use systemd; then
		sed -e 's/${SYSTEMD_KERNEL_INSTALL:=0}/${SYSTEMD_KERNEL_INSTALL:=1}/g' -i installkernel ||
			die "enabling systemd's kernel-install failed"
	fi

	# set some default config using the flags we have anyway
	touch "${T}/install.conf" || die
	echo "# This file is managed by ${CATEGORY}/${PN}" >> "${T}/install.conf" || die
	if use uki; then
		echo "layout=uki" >> "${T}/install.conf" || die
	elif use systemd-boot; then
		echo "layout=bls" >> "${T}/install.conf" || die
	elif use grub; then
		echo "layout=grub" >> "${T}/install.conf" || die
	else
		echo "layout=compat" >> "${T}/install.conf" || die
	fi

	if use dracut; then
		echo "initrd_generator=dracut" >> "${T}/install.conf" || die
		if ! use ukify; then
			if use uki; then
				echo "uki_generator=dracut" >> "${T}/install.conf" || die
			else
				echo "uki_generator=none" >> "${T}/install.conf" || die
			fi
		fi
	else
		echo "initrd_generator=none" >> "${T}/install.conf" || die
	fi

	if use ukify; then
		echo "uki_generator=ukify" >> "${T}/install.conf" || die
	else
		if ! use dracut; then
			echo "uki_generator=none" >> "${T}/install.conf" || die
		fi
	fi

	insinto /usr/lib/kernel
	doins "${T}/install.conf"

	into /
	dosbin installkernel
	doman installkernel.8

	einstalldocs
}

pkg_postinst() {
	# show only when upgrading to 14+
	if [[ -n "${REPLACING_VERSIONS}" ]] && ver_test "${REPLACING_VERSIONS}" -lt 14; then
		elog "Version 14 and up of ${PN} effectively merges"
		elog "${PN}-gentoo and ${PN}-systemd."
		elog "Switching between the traditional installkernel and systemd's"
		elog "kernel-install is controlled with the systemd USE flag or the"
		elog "SYSTEMD_KERNEL_INSTALL environment variable."
		elog
		elog "See the installkernel wiki page[1] for more details."
		elog
		elog "[1]: https://wiki.gentoo.org/wiki/Installkernel"
		elog
	fi

	# show only on first install of version 20+
	if [[ -z "${REPLACING_VERSIONS}" ]] || ver_test "${REPLACING_VERSIONS}" -lt 20; then
		if has_version "sys-boot/grub" && ! use grub; then
			elog "sys-boot/grub is installed but the grub USE flag is not enabled."
			elog "Users may want to enable this flag to automatically update the"
			elog "bootloader configuration on each kernel install."
		fi
		if ( has_version "sys-apps/systemd[boot]" ||
			has_version "sys-apps/systemd-utils[boot]" ) &&
			! use systemd-boot; then
				elog "systemd-boot is installed but the systemd-boot USE flag"
				elog "is not enabled. Users should enable this flag to install kernels"
				elog "in a layout that systemd-boot understands and to automatically"
				elog "update systemd-boot's configuration on each kernel install."
		fi
	fi
}
