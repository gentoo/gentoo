# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="ModemManager bindings for Qt"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm64"
IUSE=""

# requires running environment
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,xml]
	net-misc/modemmanager
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
