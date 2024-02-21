# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="NetworkManager bindings for Qt"

LICENSE="LGPL-2"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="teamd"

DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
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
