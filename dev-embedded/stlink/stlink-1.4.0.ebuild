# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils linux-info udev

DESCRIPTION="On board debugger driver for stm32-discovery boards."
HOMEPAGE="https://github.com/texane/stlink"
SRC_URI="https://github.com/texane/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk stlinkv1"

DEPEND="virtual/libusb:1[udev]
	gtk? ( x11-libs/gtk+:3 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.0-pkg-config.patch"
	"${FILESDIR}/${PN}-1.4.0-no-static-libs.patch"
	)

pkg_setup() {
	if use stlinkv1 ; then
		linux-info_pkg_setup
		linux_config_exists
		if ! linux_chkconfig_module USB_STORAGE; then
			ewarn "To use stlinkv1 devices you must build USB_STORAGE as module"
			ewarn "or add usb-storage.quirks=483:3744:i as boot parameter."
		fi
	fi
}

src_prepare() {
	# fix shared library name
	sed 's/-shared//' -i CMakeLists.txt || die

	# gtk-detection is done automagically
	use gtk || sed '/gtk/d' -i CMakeLists.txt || die

	# remove -Werror
	sed '/Werror/d' -i cmake/CFlags.cmake || die

	default
}

src_configure() {
	local mycmakeargs=(
		-DSTLINK_UDEV_RULES_DIR=$(get_udevdir)
		-DPKG_CONFIG_LIBDIR=$(get_libdir)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	udev_reload
}
