# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm gear.kde.org optfeature xdg

DESCRIPTION="Plasma filemanager focusing on usability"
HOMEPAGE="https://apps.kde.org/dolphin/ https://userbase.kde.org/Dolphin"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="semantic-desktop telemetry"

# slot op: Uses Qt::GuiPrivate for qtx11extras_p.h
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,dbus,gui,widgets,X,xml]
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kfilemetadata-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6=
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=media-libs/phonon-4.12.0[qt6(+)]
	semantic-desktop? (
		>=kde-apps/baloo-widgets-${PVCUT}:6
		>=kde-frameworks/baloo-${KFMIN}:6
	)
	telemetry? ( >=kde-frameworks/kuserfeedback-${KFMIN}:6 )
"
RDEPEND="${DEPEND}
	>=kde-apps/kio-extras-${PVCUT}:6
	>=kde-apps/thumbnailers-${PVCUT}:6
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PackageKitQt6=ON
		$(cmake_use_find_package semantic-desktop KF6Baloo)
		$(cmake_use_find_package semantic-desktop KF6BalooWidgets)
		$(cmake_use_find_package telemetry KF6UserFeedback)
	)
	use test && mycmakeargs+=(
		-DCMAKE_DISABLE_FIND_PACKAGE_SeleniumWebDriverATSPI=ON # not packaged
	)
	ecm_src_configure
}

src_test() {
	local myctestargs=(
		# servicemenuinstaller requires ruby, no thanks
		# dolphinmainwindowtest, kitemlistcontrollertest, kfileitemlistviewtest, kfileitemmodeltest hang forever
		# placesitemmodeltest requires DBus
		-E "(servicemenuinstaller|dolphinmainwindowtest|kfileitemlistviewtest|kfileitemmodeltest|kitemlistcontrollertest|placesitemmodeltest)"
	)
	ecm_src_test
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "compress/extract and other actions" "kde-apps/ark:${SLOT}"
		optfeature "crypto actions" "kde-apps/kleopatra:${SLOT}"
		optfeature "'Share' context menu actions" "kde-frameworks/purpose:${SLOT}"
	fi
	xdg_pkg_postinst
}
