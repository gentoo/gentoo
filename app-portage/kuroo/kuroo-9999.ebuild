# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.96.0
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
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/threadweaver-${KFMIN}:5
"
RDEPEND="${DEPEND}
	app-portage/gentoolkit
	kde-apps/kompare:5
"

pkg_postinst() {
	if ! has_version app-admin/logrotate ; then
		elog "Installing app-admin/logrotate is recommended to keep"
		elog "portage's summary.log size reasonable to view in the history page."
	fi

	ecm_pkg_postinst
}
