# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.6.0
QTMIN=6.7.2
ESVN_REPO_URI="https://svn.code.sf.net/p/kuroo/code/kuroo4/trunk"
inherit ecm subversion

DESCRIPTION="Graphical Portage frontend based on KDE Frameworks"
HOMEPAGE="https://sourceforge.net/projects/kuroo/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-db/sqlite:3
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/threadweaver-${KFMIN}:6
"
RDEPEND="${DEPEND}
	app-portage/gentoolkit
	kde-misc/kdiff3
"
BEDEPEND=">=dev-build/cmake-3.30.2"

pkg_postinst() {
	if ! has_version app-admin/logrotate ; then
		elog "Installing app-admin/logrotate is recommended to keep"
		elog "portage's summary.log size reasonable to view in the history page."
	fi

	ecm_pkg_postinst
}
