# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ESVN_REPO_URI="http://kuroo.svn.sourceforge.net/svnroot/kuroo/kuroo4/trunk"
ESVN_PROJECT="kuroo4"
inherit cmake-utils subversion

DESCRIPTION="Graphical Portage frontend based on KDE Frameworks"
HOMEPAGE="http://kuroo.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE=""

COMMON_DEPEND="
	dev-db/sqlite:3
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kdelibs4support:5
	kde-frameworks/ki18n:5
	kde-frameworks/kio:5
	kde-frameworks/kitemviews:5
	kde-frameworks/knotifications:5
	kde-frameworks/ktextwidgets:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kxmlgui:5
	kde-frameworks/threadweaver:5
"
RDEPEND="${COMMON_DEPEND}
	app-portage/gentoolkit
	kde-apps/kompare:5
	kde-plasma/kde-cli-tools:5[kdesu]
"
DEPEND="${COMMON_DEPEND}
	kde-frameworks/extra-cmake-modules:5
"

pkg_postinst() {
	if ! has_version app-admin/logrotate ; then
		elog "Installing app-admin/logrotate is recommended to keep"
		elog "portage's summary.log size reasonable to view in the history page."
	fi

	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
