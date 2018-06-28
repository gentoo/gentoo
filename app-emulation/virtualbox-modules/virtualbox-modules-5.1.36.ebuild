# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# XXX: the tarball here is just the kernel modules split out of the binary
#      package that comes from virtualbox-bin

EAPI=6

inherit eutils linux-mod user

MY_P=vbox-kernel-module-src-${PV}
DESCRIPTION="Kernel Modules for Virtualbox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://dev.gentoo.org/~polynomial-c/virtualbox/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pax_kernel"

RDEPEND="!=app-emulation/virtualbox-9999"

S=${WORKDIR}

BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
MODULE_NAMES="vboxdrv(misc:${S}) vboxnetflt(misc:${S}) vboxnetadp(misc:${S}) vboxpci(misc:${S})"

pkg_setup() {
	enewgroup vboxusers

	CONFIG_CHECK="!TRIM_UNUSED_KSYMS"
	ERROR_TRIM_UNUSED_KSYMS="The kernel option CONFIG_TRIM_UNUSED_KSYMS removed kernel symbols that are needed by ${PN} to load correctly."

	linux-mod_pkg_setup

	BUILD_PARAMS="KERN_DIR=${KV_DIR} O=${KV_OUT_DIR} V=1 KBUILD_VERBOSE=1"
}

src_prepare() {
	if kernel_is -ge 2 6 33 ; then
		# evil patch for new kernels - header moved
		grep -lR linux/autoconf.h *  | xargs sed -i -e 's:<linux/autoconf.h>:<generated/autoconf.h>:'
	fi

	if use pax_kernel && kernel_is -ge 3 0 0 ; then
		eapply "${FILESDIR}"/${PN}-4.1.4-pax-const.patch
	fi

	if kernel_is -ge 4 14 0 ; then
		eapply "${FILESDIR}"/${PN}-5.1.30-udp.patch
	fi

	default
}

src_install() {
	linux-mod_src_install
	insinto /usr/lib/modules-load.d/
	doins "${FILESDIR}"/virtualbox.conf
}

pkg_postinst() {
	linux-mod_pkg_postinst
}
