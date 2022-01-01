# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.71.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.14.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Extra Plasma applets and engines"

LICENSE="GPL-2 LGPL-2"
SLOT="5"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="+comic share webengine"

RESTRICT+=" test" # bug 727846

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kholidays-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kunitconversion-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	comic? ( >=kde-frameworks/kross-${KFMIN}:5 )
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:5 )
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-plasma/plasma-workspace-${PVCUT}:5
"

PATCHES=(
	"${FILESDIR}/${P}-fix-potd.patch" # in Plasma/5.20
	"${FILESDIR}/${PN}-5.19.3-kross-optional.patch" # downstream patch
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package comic KF5Kross)
		$(cmake_use_find_package share KF5Purpose)
		$(cmake_use_find_package webengine Qt5WebEngine)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		has_version sys-fs/quota || \
			elog "For using disk quota applet, install sys-fs/quota."
	fi
}
