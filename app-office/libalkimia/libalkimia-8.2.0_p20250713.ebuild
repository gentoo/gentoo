# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_BRANCH="8.2"
ECM_TEST="forceoptional"
KDE_ORG_NAME="alkimia"
KDE_ORG_COMMIT=c40f669625309edc41a32d7b9fbfc2e2f77150be
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm kde.org

DESCRIPTION="Library with common classes and functionality used by KDE finance applications"
HOMEPAGE="https://www.linux-apps.com/content/show.php/libalkimia?content=137323
https://community.kde.org/Alkimia"

LICENSE="LGPL-2.1"
SLOT="0/8"
KEYWORDS="~amd64"
IUSE="doc plasma webengine"

DEPEND="
	dev-libs/gmp:0=[cxx(+)]
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	plasma? (
		>=kde-frameworks/kpackage-${KFMIN}:6
		kde-plasma/libplasma:6
	)
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:6 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

PATCHES=( "${FILESDIR}/${PN}-8.1.92-pkgconfig.patch" )

src_configure() {
	local mycmakeargs=(
		-DENABLE_FINANCEQUOTE=OFF
		-DBUILD_TOOLS=ON
		-DBUILD_WITH_WEBKIT=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_MPIR=ON
		$(cmake_use_find_package doc Doxygen)
		-DBUILD_APPLETS=$(usex plasma)
		-DBUILD_WITH_WEBENGINE=$(usex webengine)
	)
	ecm_src_configure
}

src_test() {
	# bug 951641
	local CMAKE_SKIP_TESTS=(
		alkdownloadengine-qt-test
		alknewstuffenginetest
		alkonlinequotestest
		appstreamtest-onlinequoteseditor
		# these fail with USE=webengine
		alkdownloadengine-webengine-test
		alkonlinequotes-webengine-test
		alkwebpage-webengine-test
		test-qwebengine-offscreen
	)
	TZ=UTC ecm_src_test
}
