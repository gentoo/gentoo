# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd udev xorg-3 meson

DESCRIPTION="Driver for Wacom tablets and drawing devices"
HOMEPAGE="https://linuxwacom.github.io/"
LICENSE="GPL-2"
SRC_URI="https://github.com/linuxwacom/${PN}/releases/download/${P}/${P}.tar.bz2"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libwacom-2:=
	>=x11-base/xorg-server-1.13:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXinerama
	virtual/libudev:="
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

pkg_pretend() {
	linux-info_pkg_setup

	if kernel_is lt 3 17; then
		if ! linux_config_exists \
				|| ! linux_chkconfig_present TABLET_USB_WACOM \
				|| ! linux_chkconfig_present INPUT_EVDEV; then
			echo
			ewarn "If you use a USB Wacom tablet, you need to enable support in your kernel"
			ewarn "  Device Drivers --->"
			ewarn "    Input device support --->"
			ewarn "      <*>   Event interface"
			ewarn "      [*]   Tablets  --->"
			ewarn "        <*>   Wacom Intuos/Graphire tablet support (USB)"
			echo
		fi
	else
		if ! linux_config_exists \
				|| ! linux_chkconfig_present HID_WACOM; then
			echo
			ewarn "If you use a USB Wacom tablet, you need to enable support in your kernel"
			ewarn "  Device Drivers --->"
			ewarn "    HID support  --->"
			ewarn "      Special HID drivers  --->"
			ewarn "        <*> Wacom Intuos/Graphire tablet support (USB)"
			echo
		fi
	fi
}

pkg_setup() {
	linux-info_pkg_setup
}

src_configure() {
	xorg-3_flags_setup

	local emesonargs=(
		-Dsystemd-unit-dir="$(systemd_get_systemunitdir)"
		-Dudev-rules-dir="$(get_udevdir)/rules.d"
		$(meson_feature test unittests)
		-Dwacom-gobject=disabled
	)
	meson_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
