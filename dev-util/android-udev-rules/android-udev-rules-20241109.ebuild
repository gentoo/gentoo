# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="Android udev rules list aimed to be the most comprehensive on the net"
HOMEPAGE="https://github.com/M0Rf30/android-udev-rules"
SRC_URI="https://github.com/M0Rf30/android-udev-rules/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# No tests
RESTRICT="test"

RDEPEND="
	acct-group/android
	virtual/udev
"

src_prepare() {
	default

	# Use the pre-existing android group
	sed -i 's/GROUP="adbusers"/GROUP="android"/' 51-android.rules || die
}

src_install() {
	udev_dorules 51-android.rules
	einstalldocs
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
