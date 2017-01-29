# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools linux-info udev user

DESCRIPTION="Program for querying and changing monitor settings"
HOMEPAGE="http://www.ddcutil.com/"

SRC_URI="https://github.com/rockowitz/ddcutil/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# Binary drivers need special instructions compared to the open source counterparts.
# If a user switches drivers, they will need to set different use flags for
# Xorg or Wayland or Mesa, so this will trigger the rebuild against
# the different drivers.
# Remove ATI/AMD driver since it's masked for removal.
# Will most likely need to set this for AMDGPU when in portage.
IUSE="enable-api-libs usb-monitor user-permissions video_cards_nvidia"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libXrandr
	 x11-libs/libX11
	 dev-libs/glib:2
	 sys-apps/i2c-tools
	 virtual/udev
	 usb-monitor? (
		dev-libs/hidapi
		virtual/libusb:1
		sys-apps/usbutils )"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

pkg_pretend() {
	# This program needs /dev/ic2-* devices to communicate with the monitor.
	CONFIG_CHECK="~I2C_CHARDEV"
	ERROR_I2C_CHARDEV="You must enable I2C_CHARDEV in your kernel to continue"
	if use usb-monitor; then
		CONFIG_CHECK+="~HIDRAW ~USB_HIDDEV"
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
	# Python API is still very experimental.
	local myeconfargs=(
		$(use_enable enable-api-libs lib)
		$(use_enable usb-monitor usb)
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
		einfo "=================================================================="
		einfo "Please read the following webpage on proper usage with the nVidia "
		einfo "binary drivers, or it may not work: http://www.ddcutil.com/nvidia/"
		einfo "=================================================================="
	fi
}
