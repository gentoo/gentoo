# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.247.0
QTMIN=6.6.0
inherit ecm plasma.kde.org

DESCRIPTION="KDE Plasma resources management GUI"
HOMEPAGE="https://userbase.kde.org/Discover"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64"
IUSE="+firmware flatpak telemetry webengine" # snap: bug #919416

# libmarkdown (app-text/discount) only used in PackageKitBackend
DEPEND="
	>=dev-libs/appstream-1.0.0:=[qt6]
	dev-libs/kirigami-addons:6
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,dbus,gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/attica-${KFMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/purpose-${KFMIN}:6
	firmware? ( >=sys-apps/fwupd-1.9.4 )
	flatpak? ( sys-apps/flatpak )
	telemetry? ( >=kde-frameworks/kuserfeedback-${KFMIN}:6 )
	webengine? ( >=dev-qt/qtwebview-${QTMIN}:6 )
"
# 	snap? ( sys-libs/snapd-glib:=[qt6(-)] )
RDEPEND="${DEPEND}"
# 	snap? ( app-containers/snapd )
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

PATCHES=(
	"${FILESDIR}/${PN}-5.25.90-tests-optional.patch"
	"${FILESDIR}/${PN}-5.91.0-kuserfeedback-optional.patch"
)

src_prepare() {
	ecm_src_prepare
	# we don't need it with PackageKitBackend off
	ecm_punt_kf_module Archive
	# we don't do anything with this
	sed -e "s/^pkg_check_modules.*Markdown/#&/" \
		-e "s/^pkg_check_modules.*RpmOstree/#&/" \
		-e "s/^pkg_check_modules.*Ostree/#&/" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		# TODO: Port PackageKit's portage back-end to python3
		-DCMAKE_DISABLE_FIND_PACKAGE_packagekitqt6=ON
		# Automated updates will not work for us
		# https://invent.kde.org/plasma/discover/-/merge_requests/142
		-DWITH_KCM=OFF
		-DBUILD_DummyBackend=OFF
		-DBUILD_FlatpakBackend=$(usex flatpak)
		-DBUILD_FwupdBackend=$(usex firmware)
		-DBUILD_RpmOstreeBackend=OFF
# 		-DBUILD_SnapBackend=$(usex snap)
		-DBUILD_SteamOSBackend=OFF
		$(cmake_use_find_package telemetry KF6UserFeedback)
		$(cmake_use_find_package webengine Qt6WebView)
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
