# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ESVN_REPO_URI="https://svn.code.sf.net/p/kuroo/code/kuroo4/trunk"
inherit cmake-utils subversion xdg-utils

DESCRIPTION="Graphical Portage frontend based on KDE Frameworks"
HOMEPAGE="https://sourceforge.net/projects/kuroo/"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE=""

BDEPEND="
	kde-frameworks/extra-cmake-modules:5
"
DEPEND="
	dev-db/sqlite:3
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde-frameworks/kauth:5
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
RDEPEND="${DEPEND}
	app-portage/gentoolkit
	kde-apps/kompare:5
	kde-plasma/kde-cli-tools:5[kdesu]
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
