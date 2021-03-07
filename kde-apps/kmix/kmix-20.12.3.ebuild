# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="false"
KFMIN=5.75.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Volume control gui based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/en/kmix"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="alsa plasma pulseaudio"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	alsa? ( >=media-libs/alsa-lib-1.0.14a )
	plasma? ( >=kde-frameworks/plasma-${KFMIN}:5 )
	pulseaudio? (
		media-libs/libcanberra
		>=media-sound/pulseaudio-0.9.12
	)
"
RDEPEND="${DEPEND}
	kde-plasma/kde-cli-tools:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package alsa ALSA)
		$(cmake_use_find_package plasma KF5Plasma)
		$(cmake_use_find_package pulseaudio Canberra)
		$(cmake_use_find_package pulseaudio PulseAudio)
	)

	ecm_src_configure
}
