# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_QTHELP="false"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Library for providing abstractions to get the developer's purposes fulfilled"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+kaccounts"

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	kaccounts? (
		$(add_kdeapps_dep kaccounts-integration)
		net-libs/accounts-qt
	)
"
RDEPEND="${DEPEND}"

# requires running environment
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package kaccounts KAccounts)
	)

	kde5_src_configure
}

pkg_postinst(){
	kde5_pkg_postinst

	if ! has_version "kde-misc/kdeconnect[app]" ; then
		elog
		elog "Optional runtime dependency:"
		elog "kde-misc/kdeconnect[app] (send through KDE Connect)"
		elog
	fi
}
