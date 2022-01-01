# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_QTHELP="false" # TODO: figure out install error
ECM_TEST="forceoptional"
KFMIN=5.74.0
QTMIN=5.15.1
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KDE UML Modeller"
HOMEPAGE="https://apps.kde.org/en/umbrello https://umbrello.kde.org"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm64 x86"
IUSE="php"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	php? (
		dev-util/kdevelop:5=
		dev-util/kdevelop-pg-qt:5
		dev-util/kdevelop-php:5
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-{no,unused}-qtwebkit.patch
	"${FILESDIR}"/${P}-gentoo-docbundledir.patch # downstream fix hardcoded path
	"${FILESDIR}"/${P}-unbundle-kdevelop-php.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON # broken, re-enable w/ ECM_QTHELP
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebKitWidgets=ON
		-DBUILD_APIDOC=OFF
		-DBUILD_KF5=ON
		-DBUILD_PHP_IMPORT=$(usex php)
		-DBUILD_unittests=$(usex test)
	)
	use test && mycmakeargs+=(
		-DCMAKE_DISABLE_FIND_PACKAGE_LLVM=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Clang=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_CLANG=ON
	)

	ecm_src_configure
}
