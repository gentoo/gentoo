# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KMNAME="kde-wallpapers"
KDE_AUTODEPS="false"
KDE_DEBUG="false"
inherit kde5

DESCRIPTION="KDE wallpapers"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
"
RDEPEND="!kde-apps/kde-wallpapers:4"

PATCHES=( "${FILESDIR}/${PN}-15.08.0-kf5-port.patch" ) # bug 559156

src_install() {
	kde5_src_install
	rm -r "${ED}"usr/share/wallpapers/Autumn || die
}
