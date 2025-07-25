# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Client for Matrix, the decentralized communication protocol"
HOMEPAGE="https://apps.kde.org/neochat/"

LICENSE="GPL-3+ handbook? ( CC-BY-SA-4.0 )"
SLOT="0"
KEYWORDS="amd64 ~arm64"

DEPEND="
	app-text/cmark:=
	dev-libs/kirigami-addons:6
	>=dev-libs/icu-61.0:=
	dev-libs/qcoro[network]
	>=dev-libs/qtkeychain-0.14.2:=[qt6(+)]
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwebview-${QTMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6[qml]
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/purpose-${KFMIN}:6
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6[qml]
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	media-libs/kquickimageeditor:6
	>=net-libs/libquotient-0.9.0:=
"
RDEPEND="${DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtlocation-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	>=dev-qt/qtpositioning-${QTMIN}:6[qml]
	>=kde-frameworks/kquickcharts-${KFMIN}:6
	>=kde-frameworks/prison-${KFMIN}:6[qml]
"
BDEPEND="virtual/pkgconfig"

CMAKE_SKIP_TESTS=(
	# bug 938530, i18n bs
	eventhandlertest
	# bug 909816, tries access /proc/PID/mem
	texthandlertest # ki18n (KLocalizedString) failure
)

src_configure() {
	local mycmakeargs=(
		# TODO: kunifiedpush not yet packaged
		-DCMAKE_DISABLE_FIND_PACKAGE_KUnifiedPush=ON
	)

	ecm_src_configure
}
