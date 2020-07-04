# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
KFMIN=5.60.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV%.0}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~ppc64 x86"
fi

DESCRIPTION="Cross-platform web browser using QtWebEngine"
HOMEPAGE="https://www.falkon.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE="dbus kde libressl +X"

COMMON_DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5[sqlite]
	>=dev-qt/qtwebchannel-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5=[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	virtual/libintl
	dbus? ( >=dev-qt/qtdbus-${QTMIN}:5 )
	kde? (
		>=kde-frameworks/kcoreaddons-${KFMIN}:5
		>=kde-frameworks/kcrash-${KFMIN}:5
		>=kde-frameworks/kio-${KFMIN}:5
		>=kde-frameworks/kwallet-${KFMIN}:5
		>=kde-frameworks/purpose-${KFMIN}:5
	)
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libxcb:=
		x11-libs/xcb-util
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/linguist-tools-${QTMIN}:5
	>=dev-qt/qtconcurrent-${QTMIN}:5
"
if [[ ${KDE_BUILD_TYPE} != live ]]; then
	DEPEND+=" >=kde-frameworks/ki18n-${KFMIN}:5"
fi
RDEPEND="${COMMON_DEPEND}
	!www-client/qupzilla
	>=dev-qt/qtsvg-${QTMIN}:5
"

PATCHES=(
	"${FILESDIR}/${P}-use-cmake-find-intl.patch"
	"${FILESDIR}/${P}-fix-warn-registering-schemes.patch"
	"${FILESDIR}/${P}-qt-5.14.patch"
	"${FILESDIR}/${P}-qt-5.15.patch"
)

# bug 653046
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DBUILD_KEYRING=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_PySide2=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Shiboken2=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonLibs=ON
		-DDISABLE_DBUS=$(usex !dbus)
		$(cmake_use_find_package kde KF5Wallet)
		$(cmake_use_find_package kde KF5KIO)
		-DNO_X11=$(usex !X)
	)
	ecm_src_configure
}
