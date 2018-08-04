# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic linux-info udev user

DESCRIPTION="Program for querying and changing monitor settings"
HOMEPAGE="http://www.ddcutil.com/"
SRC_URI="https://github.com/rockowitz/ddcutil/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="drm usb-monitor user-permissions video_cards_nvidia X"
REQUIRED_USE="drm? ( X )"

RDEPEND="dev-libs/glib:2
	sys-apps/i2c-tools
	virtual/udev
	drm? ( x11-libs/libdrm )
	usb-monitor? (
		dev-libs/hidapi
		virtual/libusb:1
		sys-apps/usbutils
	)
	X? (
		x11-libs/libXrandr
		x11-libs/libX11
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_pretend() {
	# This program needs /dev/ic2-* devices to communicate with the monitor.
	CONFIG_CHECK="~I2C_CHARDEV"
	ERROR_I2C_CHARDEV="You must enable I2C_CHARDEV in your kernel to continue"
	if use usb-monitor; then
		CONFIG_CHECK+=" ~HIDRAW ~USB_HIDDEV"
		ERROR_HIDRAW="HIDRAW is needed to support USB monitors"
		ERROR_I2C_CHARDEV="USB_HIDDEV is needed to support USB monitors"
	fi

	# Now do the actual checks setup above
	check_extra_config
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Bug 607818.
	replace-flags -O3 -O2

	local myeconfargs=(
		$(use_enable drm)
		$(use_enable usb-monitor usb)
		$(use_enable X x11)
		--enable-lib
		--disable-cffi
		--disable-cython
		--disable-swig
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	if use user-permissions; then
		udev_dorules data/etc/udev/rules.d/45-ddcutil-i2c.rules
		if use usb-monitor; then
			udev_dorules data/etc/udev/rules.d/45-ddcutil-usb.rules
		fi
	fi
}

pkg_postinst() {
	if use user-permissions; then
		enewgroup i2c
		einfo "To allow non-root users access to the /dev/i2c-* devices, add those"
		einfo "users to the i2c group: usermod -aG i2c user"
		einfo "Restart the computer or reload the i2c-dev module to activate"
		einfo "the new udev rule."
		einfo "For more information read: http://www.ddcutil.com/i2c_permissions/"

		if use usb-monitor; then
			enewgroup video
			einfo "To allow non-root users access to USB monitors, add those users"
			einfo "to the video group: usermod -aG video user"
			einfo "Restart the computer, reload the hiddev and hidraw modules, or replug"
			einfo "the monitor to activate the new udev rule."
			einfo "For more information read: http://www.ddcutil.com/usb/"
		fi

		udev_reload
	fi

	if use video_cards_nvidia; then
		ewarn "Please read the following webpage on proper usage with the nVidia "
		ewarn "binary drivers, or it may not work: http://www.ddcutil.com/nvidia/"
	fi
}
