# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="ModemManager bindings for Qt"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# requires running environment
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,xml]
	net-misc/modemmanager
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
