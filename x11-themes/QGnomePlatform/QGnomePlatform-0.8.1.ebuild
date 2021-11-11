# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="A Qt Platform Theme aimed to accommodate GNOME settings"
HOMEPAGE="https://github.com/FedoraQt/QGnomePlatform"
SRC_URI="https://github.com/FedoraQt/QGnomePlatform/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~ppc64 ~x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtdbus:5=
	>=dev-qt/qtwidgets-5.15.2:5=
	dev-qt/qtwayland:5=
	dev-qt/qtx11extras:5=
	gnome-base/gsettings-desktop-schemas
	sys-apps/xdg-desktop-portal
	x11-libs/gtk+:3[X]
	>=x11-themes/adwaita-qt-1.4.1
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT6=false
	)
	cmake_src_configure
}
