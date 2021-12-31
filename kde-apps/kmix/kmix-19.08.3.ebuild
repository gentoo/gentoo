# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="false"
KFMIN=5.60.0
PLASMA_MINIMAL=5.16.5
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Plasma mixer gui"
HOMEPAGE="https://kde.org/applications/multimedia/kmix/"
LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="alsa pulseaudio"

DEPEND="
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	alsa? ( >=media-libs/alsa-lib-1.0.14a )
	pulseaudio? (
		dev-libs/glib:2
		media-libs/libcanberra
		>=media-sound/pulseaudio-0.9.12
	)
"
RDEPEND="${DEPEND}
	>=kde-plasma/kde-cli-tools-${PLASMA_MINIMAL}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package alsa ALSA)
		$(cmake-utils_use_find_package pulseaudio Canberra)
		$(cmake-utils_use_find_package pulseaudio PulseAudio)
	)

	ecm_src_configure
}
