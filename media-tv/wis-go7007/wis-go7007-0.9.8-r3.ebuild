# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils linux-mod udev

MY_PN=${PN}-linux
DESCRIPTION="Linux drivers for go7007 chipsets (Plextor ConvertX PVR)"
HOMEPAGE="http://oss.wischip.com/ http://home.comcast.net/~bender647/go7007/"
SRC_URI="http://oss.wischip.com/${MY_PN}-${PV}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"
DEPEND="virtual/udev
	sys-apps/fxload"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
	BUILD_TARGETS="all"
	BUILD_PARAMS="KERNELSRC=${KERNEL_DIR}"
	CONFIG_CHECK="HOTPLUG MODULES KMOD FW_LOADER I2C VIDEO_DEV SOUND SND USB
		USB_DEVICEFS USB_EHCI_HCD"

	if use alsa; then
		CONFIG_CHECK="${CONFIG_CHECK} SND_MIXER_OSS SND_PCM_OSS"
	fi

	if ! kernel_is ge 2 6 26; then
		eerror "This ebuild version will only work with a 2.6.26 kernel"
		die "Needs a different kernel"
	fi

	linux-mod_pkg_setup
	MODULE_NAMES="go7007(extra:${S}:${S}/kernel)
		go7007-usb(extra:${S}:${S}/kernel)
		snd-go7007(extra:${S}:${S}/kernel)
		wis-ov7640(extra:${S}:${S}/kernel)
		wis-sony-tuner(extra:${S}:${S}/kernel)
		wis-tw9903(extra:${S}:${S}/kernel)
		wis-uda1342(extra:${S}:${S}/kernel)
		wis-saa7113(extra:${S}:${S}/kernel)
		wis-saa7115(extra:${S}:${S}/kernel)"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	if kernel_is ge 2 6 26; then
		epatch "${FILESDIR}/wis-go7007-updates.diff"
		epatch "${FILESDIR}/wis-go7007-2.6.21-typdefs.diff"
		epatch "${FILESDIR}/wis-go7007-2.6.24-no_algo_control.diff"
		epatch "${FILESDIR}/wis-go7007-2.6.26-nopage.diff"
	fi
}

src_compile() {
	linux-mod_src_compile || die "failed to build driver "
}

src_install() {
	cd "${S}/apps"
	make KERNELDIR="${KERNEL_DIR}" DESTDIR="${D}" PREFIX=/usr install || die "failed to install"
	cd "${S}"
	dodir "/lib/modules"
	insinto "/lib/modules"
	dodoc README README.saa7134 RELEASE-NOTES
	cd "${S}/kernel"
	linux-mod_src_install || die "failed to install modules"

	insinto "${KERNEL_DIR}/include/linux"
	doins "${S}/include/*.h"
	insinto "/lib/firmware"
	doins "${S}/firmware/*.bin"
	insinto "/lib/firmware/ezusb"
	doins "${S}/firmware/ezusb/*.hex"
	udev_dorules "${S}/udev/wis-ezusb.rules"

	exeinto "/usr/bin"
	use alsa && doexe "${S}/apps/gorecord"
	doexe "${S}/apps/modet"
}

pkg_postinst() {
	linux-mod_pkg_postinst

	elog ""
	elog "For more information on how to use the Plextor devices with Gentoo"
	elog "you can follow this thread for tips and tricks:"
	elog "http://forums.gentoo.org/viewtopic-t-306559-highlight-.html"
	elog ""
	elog "Also, the unofficial Gentoo wiki has a HOWTO page:"
	elog "http://gentoo-wiki.com/HARDWARE_go7007"
	elog ""
	ewarn "Don't forget to add your modules to /etc/modules.autoload.d/kernel.2.6"
	ewarn "so they will load on startup:"
	ewarn ""
	ewarn "snd_go7007"
	ewarn "go7007"
	ewarn "go7007_usb"
	ewarn "wis_saa7115"
	ewarn "wis_uda1342"
	ewarn "wis_sony_tuner"
}
