# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot

MY_P=vanilla-kernel-${PV}-r1-1
DESCRIPTION="Pre-built vanilla Linux kernel"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="
	amd64? (
		https://dev.gentoo.org/~mgorny/binpkg/amd64/kernel/sys-kernel/vanilla-kernel/${MY_P}.xpak
			-> ${MY_P}.amd64.xpak
	)
	x86? (
		https://dev.gentoo.org/~mgorny/binpkg/x86/kernel/sys-kernel/vanilla-kernel/${MY_P}.xpak
			-> ${MY_P}.x86.xpak
	)"
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+initramfs"

# install-DEPEND actually
# note: we need installkernel with initramfs support!
RDEPEND="
	|| (
		sys-kernel/installkernel-gentoo
		sys-kernel/installkernel-systemd-boot
	)
	initramfs? ( sys-kernel/dracut )
	!sys-kernel/vanilla-kernel:${SLOT}"

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

src_install() {
	# cp is easier for preserving +x bits
	cp -p -R . "${ED}" || die
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
}

pkg_prerm() {
	:
}

pkg_postrm() {
	rm -f "${EROOT}/usr/src/linux-${PV}/initrd" &&
	rmdir --ignore-fail-on-non-empty "${EROOT}/usr/src/linux-${PV}"
}
