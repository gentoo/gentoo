# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot

MY_P=vanilla-kernel-${PV}-1
TCL_VER=10.1
DESCRIPTION="Pre-built vanilla Linux kernel"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="
	amd64? (
		https://dev.gentoo.org/~mgorny/binpkg/amd64/kernel/sys-kernel/vanilla-kernel/${MY_P}.xpak
			-> ${MY_P}.amd64.xpak
		test? (
			https://dev.gentoo.org/~mgorny/dist/tinycorelinux-${TCL_VER}-amd64.qcow2
		)
	)
	x86? (
		https://dev.gentoo.org/~mgorny/binpkg/x86/kernel/sys-kernel/vanilla-kernel/${MY_P}.xpak
			-> ${MY_P}.x86.xpak
		test? (
			https://dev.gentoo.org/~mgorny/dist/tinycorelinux-${TCL_VER}-x86.qcow2
		)
	)"
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+initramfs test"
RESTRICT="!test? ( test ) test? ( userpriv )"

# install-DEPEND actually
# note: we need installkernel with initramfs support!
RDEPEND="
	|| (
		sys-kernel/installkernel-gentoo
		sys-kernel/installkernel-systemd-boot
	)
	initramfs? ( >=sys-kernel/dracut-049-r2 )
	!sys-kernel/vanilla-kernel:${SLOT}"
BDEPEND="
	test? (
		dev-tcltk/expect
		sys-kernel/dracut
		amd64? ( app-emulation/qemu[qemu_softmmu_targets_x86_64] )
		x86? ( app-emulation/qemu[qemu_softmmu_targets_i386] )
	)"

QA_PREBUILT='*'

pkg_pretend() {
	mount-boot_pkg_pretend

	ewarn "This is an experimental package.  The built kernel and/or initramfs"
	ewarn "may not work at all or fail with your bootloader configuration.  Please"
	ewarn "make sure to keep a backup kernel available before testing it."
}

src_unpack() {
	ebegin "Unpacking ${MY_P}.${ARCH}.xpak"
	tar -x < <(xz -c -d --single-stream "${DISTDIR}/${MY_P}.${ARCH}.xpak")
	eend ${?} || die "Unpacking ${MY_P} failed"
}

src_test() {
	local image_arch=${ARCH}
	local qemu_arch=$(usex amd64 x86_64 i386)

	dracut \
		--conf /dev/null \
		--confdir /dev/null \
		--no-hostonly \
		--kmoddir "lib/modules/${PV}" \
		"${T}/initrd" "${PV}" || die
	cp "${DISTDIR}/tinycorelinux-${TCL_VER}-${image_arch}.qcow2" \
		"${T}/fs.qcow2" || die

	cd "${T}" || die
	cat > run.sh <<-EOF || die
		#!/bin/sh
		exec qemu-system-${qemu_arch} \
			-m 256M \
			-display none \
			-no-reboot \
			-kernel '${WORKDIR}/usr/src/linux-${PV}/bzImage' \
			-initrd '${T}/initrd' \
			-serial mon:stdio \
			-hda '${T}/fs.qcow2' \
			-append 'root=/dev/sda console=ttyS0,115200n8'
	EOF
	chmod +x run.sh || die
	# TODO: initramfs does not let core finish starting on some systems,
	# figure out how to make it better at that
	expect - <<-EOF || die "Booting kernel failed"
		set timeout 900
		spawn ./run.sh
		expect {
			"Kernel panic" {
				send_error "\n* Kernel panic"
				exit 1
			}
			"Entering emergency mode" {
				send_error "\n* Initramfs failed to start the system"
				exit 1
			}
			"Core 10.1" {
				send_error "\n* Booted to login"
				exit 0
			}
			timeout {
				send_error "\n* Kernel boot timed out"
				exit 2
			}
		}
	EOF
}

src_install() {
	mv * "${ED}" || die
}

pkg_preinst() {
	:
}

pkg_postinst() {
	if [[ -z ${ROOT} ]]; then
		mount-boot_pkg_preinst

		if use initramfs; then
			ebegin "Building initramfs via dracut"
			# putting it alongside kernel image as 'initrd' makes
			# kernel-install happier
			dracut --force "${EROOT}/usr/src/linux-${PV}/initrd" "${PV}"
			eend ${?} || die "Building initramfs failed"
		fi

		ebegin "Installing the kernel via installkernel"
		# note: .config is taken relatively to System.map;
		# initrd relatively to bzImage
		installkernel "${PV}" \
			"${EROOT}/usr/src/linux-${PV}/bzImage" \
			"${EROOT}/usr/src/linux-${PV}/System.map"
		eend ${?} || die "Installing the kernel failed"
	fi

	if [[ ! -e ${EROOT}/usr/src/linux ]]; then
		ebegin "Creating /usr/src/linux symlink"
		ln -f -n -s linux-${PV} "${EROOT}"/usr/src/linux
		eend ${?}
	else
		local symlink_target=$(readlink "${EROOT}"/usr/src/linux)
		local symlink_ver=${symlink_target#linux-}
		if [[ ${symlink_target} == linux-* && -z ${symlink_ver//[0-9.]/} ]]
		then
			local symlink_pkg=${CATEGORY}/${PN}-${symlink_ver}
			# if the current target is either being replaced, or still
			# installed (probably depclean candidate), update the symlink
			if has "${symlink_ver}" ${REPLACING_VERSIONS} ||
					has_version -r "~${symlink_pkg}"
			then
				ebegin "Updating /usr/src/linux symlink"
				ln -f -n -s linux-${PV} "${EROOT}"/usr/src/linux
				eend ${?}
			fi
		fi
	fi
}

pkg_prerm() {
	:
}

pkg_postrm() {
	rm -f "${EROOT}/usr/src/linux-${PV}/initrd" &&
	rmdir --ignore-fail-on-non-empty "${EROOT}/usr/src/linux-${PV}"
}
