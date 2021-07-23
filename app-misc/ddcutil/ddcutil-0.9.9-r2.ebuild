# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic linux-info udev

DESCRIPTION="Program for querying and changing monitor settings"
HOMEPAGE="http://www.ddcutil.com/"
SRC_URI="https://github.com/rockowitz/ddcutil/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="drm introspection usb-monitor user-permissions video_cards_nvidia X"
REQUIRED_USE="drm? ( X )"

RDEPEND="
	dev-libs/glib:2
	sys-apps/i2c-tools
	virtual/udev
	drm? ( x11-libs/libdrm )
	introspection? ( >=dev-libs/gobject-introspection-1.54.0:= )
	usb-monitor? (
		dev-libs/hidapi
		virtual/libusb:1
		sys-apps/usbutils
	)
	user-permissions? (
		acct-group/i2c
		usb-monitor? ( acct-group/video )
	)
	X? (
		x11-libs/libXrandr
		x11-libs/libX11
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

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
	sed -e "s#usr/local/bin#usr/bin#" -i data/etc/udev/rules.d/45-ddcutil-usb.rules || die
}

src_configure() {
	# Bug 607818.
	replace-flags -O3 -O2

	local myeconfargs=(
		$(use_enable drm)
		$(use_enable usb-monitor usb)
		$(use_enable X x11)
		--enable-lib
		# Please read upstream's note about the original purpose of these flags before re-enabling them:
		# https://github.com/rockowitz/ddcutil/issues/128
		# As of 0.9.9 the following no longer compile:
		# Python3 & CFFI is already broken as of Python 3.7, with future removal;
		# SWIG : Python3.7 breakage as well PyFileObject vs PyCodeObject
		--disable-cffi
		--disable-cython
		--disable-swig
		$(use_enable introspection)
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
		einfo "To allow non-root users access to the /dev/i2c-* devices, add those"
		einfo "users to the i2c group: usermod -aG i2c user"
		einfo "Restart the computer or reload the i2c-dev module to activate"
		einfo "the new udev rule."
		einfo "For more information read: http://www.ddcutil.com/i2c_permissions/"

		if use usb-monitor; then
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
