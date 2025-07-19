# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
KDE_ORG_COMMIT=2a2b4273239b7f9106582db53e2db9bd27e77cb0
PVCUT=$(ver_cut 1-3)
KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm gear.kde.org xdg

DESCRIPTION="Program that helps to learn and practice touch typing"
HOMEPAGE="https://apps.kde.org/ktouch/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv ~x86"
IUSE="X"

COMMON_DEPEND="
	dev-libs/libxml2:2=
	>=dev-qt/qtbase-${QTMIN}:6[gui,sql,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	X? (
		>=dev-qt/qtbase-${QTMIN}:6=[X]
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libxkbfile
	)
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=kde-apps/kqtquickcharts-25.07.70_pre20250625:6
"

PATCHES=( "${FILESDIR}/${PN}-25.07.80-duplicate-kdoctools.patch" ) # bug 960368

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_X11=$(usex !X)
	)
	ecm_src_configure
}
