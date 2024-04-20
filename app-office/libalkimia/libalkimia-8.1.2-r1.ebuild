# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KDE_ORG_NAME="alkimia"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${KDE_ORG_NAME}/${PV}/${KDE_ORG_NAME}-${PV}.tar.xz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Library with common classes and functionality used by KDE finance applications"
HOMEPAGE="https://www.linux-apps.com/content/show.php/libalkimia?content=137323
https://community.kde.org/Alkimia"

LICENSE="LGPL-2.1"
SLOT="0/8"
IUSE="doc plasma webengine"

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
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	plasma? (
		>=kde-frameworks/kpackage-${KFMIN}:5
		>=kde-plasma/libplasma-${KFMIN}:5
	)
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:5 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

PATCHES=( "${FILESDIR}/${PN}-8.1.0-cmake.patch" )

src_configure() {
	local mycmakeargs=(
		-DENABLE_FINANCEQUOTE=OFF
		-DBUILD_TOOLS=ON
		-DBUILD_WITH_WEBKIT=OFF
		$(cmake_use_find_package doc Doxygen)
		-DCMAKE_DISABLE_FIND_PACKAGE_MPIR=ON
		-DBUILD_APPLETS=$(usex plasma)
		-DBUILD_WITH_WEBENGINE=$(usex webengine)
	)
	ecm_src_configure
}

src_test() {
	# Depends on BUILD_WITH_WEBKIT, bug 736128
	local myctestargs=(
		-E "(alkonlinequotestest)"
	)
	ecm_src_test
}
