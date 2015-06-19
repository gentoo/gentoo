# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-base/nouveau-drm/nouveau-drm-20120605.ebuild,v 1.1 2012/06/07 11:20:05 chithanh Exp $

EAPI=2

inherit linux-info linux-mod

DESCRIPTION="Nouveau DRM Kernel Modules for X11"
HOMEPAGE="http://nouveau.freedesktop.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/master

CONFIG_CHECK="~ACPI_VIDEO ~BACKLIGHT_CLASS_DEVICE ~DEBUG_FS !DRM ~FB_CFB_FILLRECT ~FB_CFB_COPYAREA ~FB_CFB_IMAGEBLIT ~FRAMEBUFFER_CONSOLE ~!FB_NVIDIA ~!FB_RIVA ~!FB_UVESA ~!FB_VGA16 ~I2C_ALGOBIT ~MXM_WMI ~VGA_ARB"

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is lt 3 3; then
		eerror "You need kernel 3.3 for this version of nouveau-drm"
		die "Incompatible kernel version"
	fi
	elog "For newer kernels newer than 2.6.32 there is integrated nouveau DRM."
	elog "Use that if you experience build issues."
}

src_compile() {
	set_arch_to_kernel
	emake \
		LINUXDIR="${KERNEL_DIR}" \
		NOUVEAUROOTDIR="${PWD}" \
		-f "${FILESDIR}"/${PN}-20100212-Makefile \
		|| die "Compiling kernel modules failed"
}

src_install() {
	insinto /lib/modules/${KV_FULL}/${PN}
	doins drivers/gpu/drm/{*/,}*.ko || die "doins failed"
}
