# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION="3.0.0"
inherit kde5

DESCRIPTION="Plasma control module for systemd"
HOMEPAGE="https://projects.kde.org/projects/playground/sysadmin/systemd-kcm"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

IUSE=""
LICENSE="GPL-2+"
KEYWORDS="amd64 ~x86"

CDEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	sys-apps/systemd
"
DEPEND="${CDEPEND}
	>=dev-libs/boost-1.45
	sys-devel/gettext
"
RDEPEND="${CDEPEND}
	!kde-misc/kcmsystemd:4
	!kde-misc/systemd-kcm:4
"
