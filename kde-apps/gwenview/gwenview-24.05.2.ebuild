# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org optfeature

DESCRIPTION="Image viewer by KDE"
HOMEPAGE="https://apps.kde.org/gwenview/ https://userbase.kde.org/Gwenview"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="activities fits +mpris raw semantic-desktop share X"

# requires running environment
RESTRICT="test"

# slot op: includes qpa/qplatformnativeinterface.h, qtx11extras_p.h
COMMON_DEPEND="
	dev-libs/wayland
	>=dev-qt/qtbase-${QTMIN}:6=[gui,opengl,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwayland-${QTMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	media-gfx/exiv2:=
	>=media-libs/kcolorpicker-0.3.1
	>=media-libs/kimageannotator-0.7.1
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/phonon-4.12.0[qt6]
	media-libs/tiff:=
	activities? ( kde-plasma/plasma-activities:6 )
	fits? ( sci-libs/cfitsio )
	mpris? ( >=dev-qt/qtbase-${QTMIN}:6[dbus] )
	raw? ( >=kde-apps/libkdcraw-${PVCUT}:6 )
	semantic-desktop? (
		>=kde-frameworks/baloo-${KFMIN}:6
		>=kde-frameworks/kfilemetadata-${KFMIN}:6
	)
	share? ( >=kde-frameworks/purpose-${KFMIN}:6 )
	X? (
		>=dev-qt/qtbase-${QTMIN}:6=[gui]
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/wayland-protocols
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtimageformats-${QTMIN}:6
	>=kde-frameworks/kimageformats-${KFMIN}:6
"
BDEPEND="
	>=dev-qt/qtwayland-${QTMIN}:6
	dev-util/wayland-scanner
"

src_prepare() {
	ecm_src_prepare
	if ! use mpris; then
		# FIXME: upstream a better solution
		sed -e "/set(HAVE_QTDBUS/s/\${Qt6DBus_FOUND}/0/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities PlasmaActivities)
		$(cmake_use_find_package fits CFitsio)
		$(cmake_use_find_package raw KDcrawQt6)
		-DGWENVIEW_SEMANTICINFO_BACKEND=$(usex semantic-desktop Baloo None)
		$(cmake_use_find_package share KF6Purpose)
		-DWITHOUT_X11=$(usex !X)
	)
	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "SVG support" "kde-apps/svgpart:${SLOT}"
	fi
	ecm_pkg_postinst
}
