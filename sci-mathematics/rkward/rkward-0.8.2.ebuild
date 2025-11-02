# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=6.9.0
QTMIN=6.6.2
inherit ecm kde.org optfeature xdg

DESCRIPTION="IDE for the R-project"
HOMEPAGE="https://rkward.kde.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~amd64-linux"
fi

LICENSE="GPL-2+ LGPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-lang/R
	dev-libs/kdsingleapplication[qt6(+)]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-frameworks/breeze-icons-${KFMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"
BDEPEND="sys-devel/gettext"

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "kate plugins support" "kde-apps/kate-addons:6"
		optfeature "prendering (or previewing) R markdown (.Rmd) files" "app-text/pandoc"
		optfeature "managing citations while writing articles" "app-text/kbibtex"
	fi
	xdg_pkg_postinst
}
