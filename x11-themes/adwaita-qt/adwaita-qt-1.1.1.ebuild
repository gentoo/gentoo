# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
"
RDEPEND="${DEPEND}
	gnome? ( x11-themes/QGnomePlatform )
"

src_configure() {
	BUILD_DIR="${WORKDIR}/${PN}_qt5"
	local mycmakeargs=( -DUSE_QT4=OFF )
	cmake_src_configure
}

src_compile() {
	local _d
	for _d in "${WORKDIR}"/${PN}_qt*; do
		cmake_src_compile -C "${_d}"
	done
}

src_install() {
	local _d
	for _d in "${WORKDIR}"/${PN}_qt*; do
		cmake_src_install -C "${_d}"
	done
}
