# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-install

MY_P=${P/-bin/}-1
DESCRIPTION="Pre-built vanilla Linux kernel"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+="
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
KEYWORDS="~amd64 ~x86"

RDEPEND="
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

src_test() {
	kernel-install_test "${PV}" \
		"${WORKDIR}/usr/src/linux-${PV}/$(kernel-install_get_image_path)" \
		"lib/modules/${PV}"
}

src_install() {
	mv * "${ED}" || die
}
