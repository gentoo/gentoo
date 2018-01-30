# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Helps integration of pure Qt4 applications with KDE Plasma"
HOMEPAGE="https://www.kde.org/"
SRC_URI="mirror://kde/Attic/applications/15.08.0/src/kde-workspace-${PV}.tar.xz"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
SLOT="4/4.11"
IUSE="debug"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	kde-frameworks/kdelibs:4
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/kde-workspace-${PV}/qguiplatformplugin_kde"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )

src_configure() {
	use debug ||  append-cppflags -DQT_NO_DEBUG
	cmake-utils_src_configure
}
