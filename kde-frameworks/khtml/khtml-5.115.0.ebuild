# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm flag-o-matic frameworks.kde.org

DESCRIPTION="KHTML web rendering engine"

LICENSE="LGPL-2"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="X"

RDEPEND="
	dev-libs/openssl:0
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	=kde-frameworks/karchive-${PVCUT}*:5
	=kde-frameworks/kcodecs-${PVCUT}*:5
	=kde-frameworks/kcompletion-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kglobalaccel-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kiconthemes-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/kjobwidgets-${PVCUT}*:5
	=kde-frameworks/kjs-${PVCUT}*:5
	=kde-frameworks/knotifications-${PVCUT}*:5
	=kde-frameworks/kparts-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/ktextwidgets-${PVCUT}*:5
	=kde-frameworks/kwallet-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	=kde-frameworks/kwindowsystem-${PVCUT}*:5[X?]
	=kde-frameworks/kxmlgui-${PVCUT}*:5
	=kde-frameworks/sonnet-${PVCUT}*:5
	media-libs/giflib:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/phonon-4.11.0[qt5(+)]
	sys-libs/zlib
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libX11
	)
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtx11extras-${QTMIN}:5 )
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	dev-lang/perl
	dev-util/gperf
"

src_configure() {
	filter-lto # bug 921686

	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
