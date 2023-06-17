# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm frameworks.kde.org

DESCRIPTION="Framework easing the development transition from KDELibs 4 to KF 5"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="X"

RESTRICT="test"

COMMON_DEPEND="
	app-text/docbook-xml-dtd:4.2
	dev-libs/openssl:0
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qttest-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kauth-${PVCUT}*:5
	=kde-frameworks/kcodecs-${PVCUT}*:5
	=kde-frameworks/kcompletion-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kcrash-${PVCUT}*:5
	=kde-frameworks/kdbusaddons-${PVCUT}*:5
	>=kde-frameworks/kded-${PVCUT}:5
	=kde-frameworks/kdoctools-${PVCUT}*:5
	=kde-frameworks/kemoticons-${PVCUT}*:5
	=kde-frameworks/kglobalaccel-${PVCUT}*:5
	=kde-frameworks/kguiaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kiconthemes-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/kitemviews-${PVCUT}*:5
	=kde-frameworks/kjobwidgets-${PVCUT}*:5
	=kde-frameworks/knotifications-${PVCUT}*:5[X?]
	=kde-frameworks/kparts-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/ktextwidgets-${PVCUT}*:5
	=kde-frameworks/kunitconversion-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	=kde-frameworks/kwindowsystem-${PVCUT}*:5[X?]
	=kde-frameworks/kxmlgui-${PVCUT}*:5
	=kde-frameworks/solid-${PVCUT}*:5
	virtual/libintl
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qtconcurrent-${QTMIN}:5 )
	X? ( x11-base/xorg-proto )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/countryflags-${PVCUT}:5
	=kde-frameworks/kinit-${PVCUT}*:5
	=kde-frameworks/kitemmodels-${PVCUT}*:5
"
BDEPEND="
	dev-lang/perl
	dev-perl/URI
"

PATCHES=(
	# downstream patches
	"${FILESDIR}/${PN}-5.80.0-no-kdesignerplugin.patch" # bug 755956
	"${FILESDIR}/${PN}-5.86.0-unused-dep.patch" # bug 755956
)

src_prepare() {
	ecm_src_prepare

	if ! use handbook; then
		sed -e "/kdoctools_install/ s/^/#DONT/" -i CMakeLists.txt || die
	fi

	cmake_run_in src cmake_comment_add_subdirectory l10n
}

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
