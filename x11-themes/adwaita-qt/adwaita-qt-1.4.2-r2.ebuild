# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A style to bend Qt applications to look like they belong into GNOME Shell"
HOMEPAGE="https://github.com/FedoraQt/adwaita-qt"
SRC_URI="https://github.com/FedoraQt/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="gnome"

DEPEND="dev-qt/qtbase:6[dbus,gui,widgets]"
RDEPEND="${DEPEND}"
PDEPEND="gnome? ( x11-themes/QGnomePlatform )"

src_configure() {
	local mycmakeargs=( -DUSE_QT6=ON )
	cmake_src_configure
}
