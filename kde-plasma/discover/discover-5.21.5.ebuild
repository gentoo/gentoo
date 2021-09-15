# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KDE Plasma resources management GUI"
HOMEPAGE="https://userbase.kde.org/Discover"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="+firmware flatpak telemetry"

# libmarkdown (app-text/discount) only used in PackageKitBackend
DEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/attica-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	firmware? ( >=sys-apps/fwupd-1.5.0 )
	flatpak? (
		>=dev-libs/appstream-0.12.8:=
		sys-apps/flatpak
	)
	telemetry? ( dev-libs/kuserfeedback:5 )
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
"

src_prepare() {
	ecm_src_prepare
	# we don't need it with PackageKitBackend off
	ecm_punt_bogus_dep KF5 Archive
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_packagekitqt5=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Snapd=ON
		-DBUILD_FlatpakBackend=$(usex flatpak)
		$(cmake_use_find_package flatpak AppStreamQt)
		-DBUILD_FwupdBackend=$(usex firmware)
		$(cmake_use_find_package telemetry KUserFeedback)
	)

	ecm_src_configure
}

src_test() {
	# bug 686392: needs network connection
	local myctestargs=(
		-E "(knsbackendtest)"
	)

	ecm_src_test
}
