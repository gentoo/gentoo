# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils

DESCRIPTION="A style to bend Qt applications to look like they belong into GNOME Shell"
HOMEPAGE="https://github.com/FedoraQt/adwaita-qt"
SRC_URI="https://github.com/FedoraQt/${PN}/archive/${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc64 ~x86"
LICENSE="GPL-2 LGPL-2"
SLOT="0"

IUSE="gnome"

RDEPEND="
	gnome? ( x11-themes/QGnomePlatform )
	dev-qt/qtwidgets:5
	dev-qt/qtdbus:5
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_configure() {
	BUILD_DIR="${WORKDIR}/${PN}_qt5"
	local mycmakeargs=( -DUSE_QT4=OFF )
	cmake-utils_src_configure
}

src_compile() {
	local _d
	for _d in "${WORKDIR}"/${PN}_qt*; do
		cmake-utils_src_compile -C "${_d}"
	done
}

src_install() {
	local _d
	for _d in "${WORKDIR}"/${PN}_qt*; do
		cmake-utils_src_install -C "${_d}"
	done
}
