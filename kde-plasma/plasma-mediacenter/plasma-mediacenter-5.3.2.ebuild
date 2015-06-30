# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/plasma-mediacenter/plasma-mediacenter-5.3.2.ebuild,v 1.1 2015/06/30 20:50:15 johu Exp $

EAPI=5

inherit kde5

DESCRIPTION="Unified media experience for any device capable of running KDE"
KEYWORDS="~amd64"
IUSE="semantic-desktop"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep plasma)
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	media-libs/taglib
	semantic-desktop? (
		$(add_plasma_dep baloo)
		$(add_plasma_dep kfilemetadata)
	)
"
RDEPEND="${DEPEND}
	$(add_plasma_dep plasma-workspace)
	dev-qt/qtmultimedia:5[qml]
	!media-video/plasma-mediacenter
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package semantic-desktop KF5Baloo)
		$(cmake-utils_use_find_package semantic-desktop KF5FileMetadata)
	)

	kde5_src_configure
}
