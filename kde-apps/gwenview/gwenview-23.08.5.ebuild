# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org optfeature

DESCRIPTION="Image viewer by KDE"
HOMEPAGE="https://apps.kde.org/gwenview/ https://userbase.kde.org/Gwenview"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="activities fits +mpris raw semantic-desktop share X"

# requires running environment
RESTRICT="test"

# slot op: includes qpa/qplatformnativeinterface.h
COMMON_DEPEND="
	dev-libs/wayland
	>=dev-qt/qtgui-${QTMIN}:5=
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	media-gfx/exiv2:=
	>=media-libs/kcolorpicker-0.2.0
	<media-libs/kcolorpicker-0.3.0
	>=media-libs/kimageannotator-0.5.0
	<media-libs/kimageannotator-0.7.0
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/phonon-4.11.0[qt5(+)]
	media-libs/tiff:=
	activities? ( >=kde-plasma/plasma-activities-${KFMIN}:5 )
	fits? ( sci-libs/cfitsio )
	mpris? ( >=dev-qt/qtdbus-${QTMIN}:5 )
	raw? ( >=kde-apps/libkdcraw-${PVCUT}:5 )
	semantic-desktop? (
		>=kde-frameworks/baloo-${KFMIN}:5
		>=kde-frameworks/kfilemetadata-${KFMIN}:5
	)
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/wayland-protocols
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtimageformats-${QTMIN}:5
	>=kde-frameworks/kimageformats-${KFMIN}:5
"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	dev-util/wayland-scanner
"

src_prepare() {
	ecm_src_prepare
	if ! use mpris; then
		# FIXME: upstream a better solution
		sed -e "/set(HAVE_QTDBUS/s/\${Qt5DBus_FOUND}/0/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package fits CFitsio)
		$(cmake_use_find_package raw KF5KDcraw)
		-DGWENVIEW_SEMANTICINFO_BACKEND=$(usex semantic-desktop Baloo None)
		$(cmake_use_find_package share KF5Purpose)
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
