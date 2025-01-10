# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.6.0
QTMIN=6.7.2
inherit ecm optfeature

if [[ ${PV} == *9999* ]] ; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/kuroo/code/kuroo4/trunk"
	inherit subversion
else
	SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Graphical Portage frontend based on KDE Frameworks"
HOMEPAGE="https://sourceforge.net/projects/kuroo/"

LICENSE="GPL-2"
SLOT="0"
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
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/threadweaver-${KFMIN}:6
"
RDEPEND="${DEPEND}
	app-portage/gentoolkit
"
BDEPEND=">=dev-build/cmake-3.30.2"

pkg_postinst() {
	if ! has_version app-admin/logrotate ; then
		elog "Installing app-admin/logrotate is recommended to keep"
		elog "portage's summary.log size reasonable to view in the history page."
	fi
	optfeature "graphical configuration merging (when run as root)" "kde-misc/kdiff3"

	ecm_pkg_postinst
}
