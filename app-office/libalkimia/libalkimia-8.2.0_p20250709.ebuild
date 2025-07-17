# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_BRANCH="8.2"
ECM_TEST="forceoptional"
KDE_ORG_NAME="alkimia"
KDE_ORG_COMMIT=234c8eae9d9960c2994b49cff9154810a09fb9d7
KFMIN=5.115.0
QTMIN=5.15.12
inherit ecm kde.org

DESCRIPTION="Library with common classes and functionality used by KDE finance applications"
HOMEPAGE="https://www.linux-apps.com/content/show.php/libalkimia?content=137323
https://community.kde.org/Alkimia"

LICENSE="LGPL-2.1"
SLOT="0/8"
KEYWORDS="amd64"
IUSE="doc"

DEPEND="
	dev-libs/gmp:0=[cxx(+)]
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
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
		-DBUILD_APPLETS=OFF
		-DBUILD_TOOLS=ON
		-DBUILD_WITH_WEBKIT=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_MPIR=ON
		$(cmake_use_find_package doc Doxygen)
		-DBUILD_WITH_WEBENGINE=OFF
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
