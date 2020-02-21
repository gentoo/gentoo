# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="true"
ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework easing the development transition from KDELibs 4 to KF 5"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="libressl X"

BDEPEND="
	dev-lang/perl
	dev-perl/URI
"
COMMON_DEPEND="
	>=kde-frameworks/kauth-${PVCUT}:5
	>=kde-frameworks/kcodecs-${PVCUT}:5
	>=kde-frameworks/kcompletion-${PVCUT}:5
	>=kde-frameworks/kconfig-${PVCUT}:5
	>=kde-frameworks/kconfigwidgets-${PVCUT}:5
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/kcrash-${PVCUT}:5
	>=kde-frameworks/kdbusaddons-${PVCUT}:5
	>=kde-frameworks/kded-${PVCUT}:5
	>=kde-frameworks/kdesignerplugin-${PVCUT}:5
	>=kde-frameworks/kdoctools-${PVCUT}:5
	>=kde-frameworks/kemoticons-${PVCUT}:5
	>=kde-frameworks/kglobalaccel-${PVCUT}:5
	>=kde-frameworks/kguiaddons-${PVCUT}:5
	>=kde-frameworks/ki18n-${PVCUT}:5
	>=kde-frameworks/kiconthemes-${PVCUT}:5
	>=kde-frameworks/kio-${PVCUT}:5
	>=kde-frameworks/kitemviews-${PVCUT}:5
	>=kde-frameworks/kjobwidgets-${PVCUT}:5
	>=kde-frameworks/knotifications-${PVCUT}:5
	>=kde-frameworks/kparts-${PVCUT}:5
	>=kde-frameworks/kservice-${PVCUT}:5
	>=kde-frameworks/ktextwidgets-${PVCUT}:5
	>=kde-frameworks/kunitconversion-${PVCUT}:5
	>=kde-frameworks/kwidgetsaddons-${PVCUT}:5
	>=kde-frameworks/kwindowsystem-${PVCUT}:5
	>=kde-frameworks/kxmlgui-${PVCUT}:5
	>=kde-frameworks/solid-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qttest-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	app-text/docbook-xml-dtd:4.2
	virtual/libintl
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/designer-${QTMIN}:5
	test? ( >=dev-qt/qtconcurrent-${QTMIN}:5 )
	X? ( x11-base/xorg-proto )
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kinit-${PVCUT}:5
	>=kde-frameworks/kitemmodels-${PVCUT}:5
	>=dev-qt/qtxml-${QTMIN}:5
"

RESTRICT+=" test"

src_prepare() {
	ecm_src_prepare
	if ! use handbook; then
		sed -e "/kdoctools_install/ s/^/#DONT/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X X11)
	)

	ecm_src_configure
}
