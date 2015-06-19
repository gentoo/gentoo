# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-plasma/sddm-kcm/sddm-kcm-5.3.1.ebuild,v 1.1 2015/05/31 22:06:16 johu Exp $

EAPI=5

inherit kde5

DESCRIPTION="KDE control module for SDDM"
HOMEPAGE="https://projects.kde.org/projects/kdereview/sddm-kcm"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	x11-libs/libXcursor
"
DEPEND="${COMMON_DEPEND}
	x11-libs/libXfixes
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	x11-misc/sddm
	!kde-misc/sddm-kcm
"

DOCS=( CONTRIBUTORS )
