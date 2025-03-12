# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm kde.org

DESCRIPTION="Personal finances manager, aiming at being simple and intuitive"
HOMEPAGE="https://skrooge.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz
		https://dev.gentoo.org/~asturm/distfiles/${P}-patchset.tar.xz"
	KEYWORDS="amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="activities kde ofx"

# hangs + installs files (also requires KF5DesignerPlugin)
RESTRICT="test"

COMMON_DEPEND="
	>=app-crypt/qca-2.3.9:2[qt6(+)]
	dev-db/sqlcipher
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,dbus,gui,network,sql,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktexttemplate-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	activities? ( kde-plasma/plasma-activities:6 )
	kde? ( >=kde-frameworks/krunner-${KFMIN}:6 )
	ofx? ( dev-libs/libofx:= )
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5
"
BDEPEND="
	dev-libs/libxslt
	virtual/pkgconfig
"

PATCHES=( "${WORKDIR}/${P}-patchset" ) # KDE-bugs #498626, #498903, #498613

src_configure() {
	local mycmakeargs=(
		-DSKG_WEBENGINE=ON
		-DSKG_DESIGNER=OFF
		$(cmake_use_find_package activities PlasmaActivities)
		$(cmake_use_find_package kde KF6Runner)
		$(cmake_use_find_package ofx LibOfx)
		-DSKG_BUILD_TEST=$(usex test)
	)

	ecm_src_configure
}

src_test() {
	local mycmakeargs=(
		-DSKG_BUILD_TEST=ON
	)
	ecm_src_test
}
