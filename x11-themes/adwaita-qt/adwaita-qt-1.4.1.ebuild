# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="A style to bend Qt applications to look like they belong into GNOME Shell"
HOMEPAGE="https://github.com/FedoraQt/adwaita-qt"
SRC_URI="https://github.com/FedoraQt/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="gnome"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
"
RDEPEND="${DEPEND}"
PDEPEND="gnome? ( x11-themes/QGnomePlatform )"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT6=false
	)
	cmake_src_configure
}

