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
IUSE="acpi"

RDEPEND="virtual/udev
	${PYTHON_DEPS}
	!x11-apps/xbacklight
	acpi? ( sys-power/acpid )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DOCS=( README.rst )

src_install() {
	python_foreach_impl python_doscript xbacklight
	udev_dorules "${S}"/90-backlight.rules
	doman xbacklight.1
	einstalldocs
	newinitd "${FILESDIR}"/acpilight.initd acpilight
	newconfd "${FILESDIR}"/acpilight.confd acpilight
	if use acpi; then
		exeinto /etc/acpi/actions
		doexe "${FILESDIR}"/acpi/actions/video_brightnessdown.sh
		doexe "${FILESDIR}"/acpi/actions/video_brightnessup.sh
		insinto /etc/acpi/events
		doins "${FILESDIR}"/acpi/events/video_brightnessdown
		doins "${FILESDIR}"/acpi/events/video_brightnessup
	fi
}

pkg_postinst() {
	udev_reload
	einfo
	elog "To use the xbacklight binary as a regular user, you must be a part of the video group"
	einfo
	elog "If this utility does not find any backlights to manipulate,"
	elog "verify you have kernel support on the device and display driver enabled."
	einfo
}
