# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="false"
KDE_TEST="false"
inherit kde5

DESCRIPTION="Plasma mixer gui"
HOMEPAGE="https://www.kde.org/applications/multimedia/kmix/"
KEYWORDS="amd64 x86"
IUSE="alsa pulseaudio"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	alsa? ( >=media-libs/alsa-lib-1.0.14a )
	pulseaudio? (
		media-libs/libcanberra
		>=media-sound/pulseaudio-0.9.12
	)
"
RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
"

src_configure() {
	local mycmakeargs=(
		-DKMIX_KF5_BUILD=ON
		$(cmake-utils_use_find_package alsa Alsa)
		$(cmake-utils_use_find_package pulseaudio Canberra)
		$(cmake-utils_use_find_package pulseaudio PulseAudio)
	)

	kde5_src_configure
}
