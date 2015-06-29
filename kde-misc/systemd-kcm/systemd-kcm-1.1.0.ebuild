# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/systemd-kcm/systemd-kcm-1.1.0.ebuild,v 1.1 2015/06/29 20:43:23 johu Exp $

EAPI=5

CMAKE_MIN_VERSION="3.0.0"
inherit kde5

DESCRIPTION="KDE control module for systemd"
HOMEPAGE="https://projects.kde.org/projects/playground/sysadmin/systemd-kcm"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

IUSE=""
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	>=dev-libs/boost-1.45
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	sys-apps/systemd
"
RDEPEND="${DEPEND}
	!kde-misc/kcmsystemd:4
	!kde-misc/systemd-kcm:4
"

# only needed for 0.7.0 and 1.1.0
S="${WORKDIR}"/kcmsystemd-${PV}
