# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qmake-utils

DESCRIPTION="A Qt Platform Theme aimed to accommodate GNOME settings"
HOMEPAGE="https://github.com/FedoraQt/QGnomePlatform"
SRC_URI="https://github.com/FedoraQt/QGnomePlatform/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~ppc64 ~x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-qt/qtwidgets-5.6:5=
	dev-qt/qtwayland:5=
	dev-qt/qtx11extras:5=
	x11-libs/gtk+:3[X]
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-qt5.15.patch" )

src_configure() {
	eqmake5
}

src_install() {
	INSTALL_ROOT="${D}" default
}
