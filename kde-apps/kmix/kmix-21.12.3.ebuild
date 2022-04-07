# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="false"
KFMIN=5.88.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Volume control gui based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/kmix/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
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
	pulseaudio? ( || (
		media-video/pipewire
		media-sound/pulseaudio-daemon
		media-sound/pulseaudio[daemon(+)]
	) )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package alsa ALSA)
		-DBUILD_DATAENGINE=$(usex plasma)
		$(cmake_use_find_package pulseaudio Canberra)
		$(cmake_use_find_package pulseaudio PulseAudio)
	)

	ecm_src_configure
}

pkg_postinst() {
	if use pulseaudio && has_version kde-plasma/plasma-pa; then
		elog "In KDE Plasma, kde-plasma/plasma-pa is the default audio volume handler."
		elog "Should you prefer this to be kde-apps/kmix instead, do the following:"
		elog " - In system tray, right click on [Show hidden items]"
		elog " - Select [Configure System Tray]"
		elog " - In [Entries],  search for [Audio Volume] and set it to [Disabled]"
		elog "KMix will be shown as [Volume Control]."
	fi
	ecm_pkg_postinst
}
