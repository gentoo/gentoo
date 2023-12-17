# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.6.0
inherit ecm frameworks.kde.org udev

DESCRIPTION="Qt wrapper for Bluez 5 DBus API"

LICENSE="LGPL-2"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUDEV_RULES_INSTALL_DIR="$(get_udevdir)/rules.d"
	)

	ecm_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# bug 668196, hangs
		managertest
	)
	# parallel tests fail, bug 609248
	ecm_src_test -j1
}

pkg_postinst() {
	ecm_pkg_postinst
	udev_reload
}

pkg_postrm() {
	ecm_pkg_postrm
	udev_reload
}
