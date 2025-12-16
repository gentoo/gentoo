# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Qt wrapper around the D-Bus API from OpenRazer"
HOMEPAGE="https://github.com/z3ntu/libopenrazer"
SRC_URI="https://github.com/z3ntu/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-qt/qtbase:6[dbus,xml]"
BDEPEND="virtual/pkgconfig"
