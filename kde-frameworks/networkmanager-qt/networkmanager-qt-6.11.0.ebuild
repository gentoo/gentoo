# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="NetworkManager bindings for Qt"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="teamd"

DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtbase-${QTMIN}:6[dbus,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=net-misc/networkmanager-1.4.0-r1[teamd=]
"
RDEPEND="${DEPEND}
	|| (
		>=net-misc/networkmanager-1.4.0-r1[elogind]
		>=net-misc/networkmanager-1.4.0-r1[systemd]
	)
"
BDEPEND="virtual/pkgconfig"

CMAKE_SKIP_TESTS=(
	# bug: 625276
	managertest
	settingstest
	activeconnectiontest
)
