# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.9
VIRTUALX_REQUIRED="test" # bug 910062 (tests hang)
inherit ecm frameworks.kde.org udev

DESCRIPTION="Qt wrapper for Bluez 5 DBus API"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
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
