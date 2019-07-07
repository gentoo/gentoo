# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="optional"
inherit kde5

DESCRIPTION="KIO Slave for Google Drive service"
HOMEPAGE="https://phabricator.kde.org/project/profile/72/"

if [[ ${KDE_BUILD_TYPE} != live ]] ; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

IUSE="+kaccounts"

COMMON_DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_kdeapps_dep libkgapi)
	$(add_qt_dep qtwidgets)
	kaccounts? ( $(add_kdeapps_dep kaccounts-integration) )
	!kaccounts? ( dev-libs/qtkeychain:=[qt5(+)] )
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
"
RDEPEND="${COMMON_DEPEND}
	kaccounts? ( $(add_kdeapps_dep kaccounts-providers) )
"
BDEPEND="dev-util/intltool"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package kaccounts KAccounts)
	)
	kde5_src_configure
}
