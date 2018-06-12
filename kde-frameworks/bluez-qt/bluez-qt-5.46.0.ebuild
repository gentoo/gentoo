# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5 udev

DESCRIPTION="Qt wrapper for Bluez 5 DBus API"
LICENSE="LGPL-2"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtnetwork)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUDEV_RULES_INSTALL_DIR="$(get_udevdir)/rules.d"
	)

	kde5_src_configure
}

src_test() {
	# bug: 609248
	local myctestargs=( -j1 )

	kde5_src_test
}
