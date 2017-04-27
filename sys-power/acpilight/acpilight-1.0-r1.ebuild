# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit python-r1 udev

DESCRIPTION="Replacement for xbacklight that uses the ACPI interface to set brightness"
HOMEPAGE="https://github.com/wavexx/acpilight/"
SRC_URI="https://github.com/wavexx/acpilight/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/udev
	${PYTHON_DEPS}
	!x11-apps/xbacklight"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DOCS=( README.rst )

src_install() {
	python_foreach_impl python_doscript xbacklight
	udev_dorules "${S}"/90-backlight.rules
	doman xbacklight.1
	einstalldocs
	newinitd "${FILESDIR}"/acpilight.initd acpilight
	newconfd "${FILESDIR}"/acpilight.confd acpilight
}

pkg_postinst() {
	udev_reload
	einfo
	elog "To use the xbacklight binary as a regular user, you must be a part of the video group"
	einfo
	elog "If this utility does not find any backlights to manipulate,"
	elog "verify you have kernel support on the device and display driver enabled."
	einfo
	elog "To take advantage of the init script, and automate the process of"
	elog "saving and restoring the brightness level you should add acpilight"
	elog "to the boot runlevel. You can do this as root like so:"
	elog "# rc-update add acpilight boot"
	einfo
}
