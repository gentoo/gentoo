# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="KDE Plasma resources management GUI"
HOMEPAGE="https://userbase.kde.org/Discover"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="+firmware flatpak snap telemetry webengine"

# libmarkdown (app-text/discount) only used in PackageKitBackend
DEPEND="
	>=dev-libs/appstream-0.15.3:=
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
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
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/purpose-${KFMIN}:5
	firmware? ( >=sys-apps/fwupd-1.5.0 )
	flatpak? ( sys-apps/flatpak )
	snap? ( sys-libs/snapd-glib:=[qt5(-)] )
	telemetry? ( kde-frameworks/kuserfeedback:5 )
	webengine? ( >=dev-qt/qtwebview-${QTMIN}:5 )
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	snap? ( app-containers/snapd )
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:5"

PATCHES=( "${FILESDIR}/${PN}-5.25.90-tests-optional.patch" )

src_prepare() {
	ecm_src_prepare
	# we don't need it with PackageKitBackend off
	ecm_punt_kf_module Archive
	# we don't do anything with this
	sed -e "s/^pkg_check_modules.*RpmOstree/#&/" \
		-e "s/^pkg_check_modules.*Ostree/#&/" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		# TODO: Port PackageKit's portage back-end to python3
		-DCMAKE_DISABLE_FIND_PACKAGE_packagekitqt5=ON
		# Automated updates will not work for us
		# https://invent.kde.org/plasma/discover/-/merge_requests/142
		-DWITH_KCM=OFF
		-DBUILD_DummyBackend=OFF
		-DBUILD_FlatpakBackend=$(usex flatpak)
		-DBUILD_FwupdBackend=$(usex firmware)
		-DBUILD_RpmOstreeBackend=OFF
		-DBUILD_SnapBackend=$(usex snap)
		-DBUILD_SteamOSBackend=OFF
		$(cmake_use_find_package telemetry KUserFeedback)
		$(cmake_use_find_package webengine Qt5WebView)
	)

	ecm_src_configure
}

src_test() {
	# bug 686392: needs network connection
	local myctestargs=(
		-E "(knsbackendtest|flatpaktest)"
	)

	ecm_src_test
}
