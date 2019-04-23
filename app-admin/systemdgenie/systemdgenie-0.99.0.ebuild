# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/unstable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="systemd managment utility"
HOMEPAGE="https://cgit.kde.org/systemdgenie.git"
LICENSE="GPL-2+"
IUSE=""

BDEPEND="sys-devel/gettext"
DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	sys-apps/systemd:=
"
RDEPEND="${DEPEND}"
