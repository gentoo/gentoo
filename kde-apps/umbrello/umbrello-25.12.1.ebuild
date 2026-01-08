# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_QTHELP="false" # TODO: figure out install error
ECM_TEST="forceoptional"
KFMIN=6.19.0
QTMIN=6.9.1
inherit ecm gear.kde.org xdg

DESCRIPTION="KDE UML Modeller"
HOMEPAGE="https://apps.kde.org/umbrello/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="php"

RDEPEND="
	dev-libs/libxml2:=
	dev-libs/libxslt
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	php? (
		dev-util/kdevelop:6=
		dev-util/kdevelop-pg-qt:0
		dev-util/kdevelop-php:6
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-24.11.80-gentoo-docbundledir.patch # fix hardcoded path
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON # broken, re-enable w/ ECM_QTHELP
		-DBUILD_APIDOC=OFF
		-DBUILD_PHP_IMPORT=$(usex php)
	)
	use test && mycmakeargs+=(
		-DCMAKE_DISABLE_FIND_PACKAGE_LLVM=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Clang=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_CLANG=ON
	)

	ecm_src_configure
}
