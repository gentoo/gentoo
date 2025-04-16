# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="false"
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Volume control gui based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/kmix/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="alsa pulseaudio"

# kde-frameworks/kwindowsystem[X]: Unconditional use of KX11Extras
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,xml]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	alsa? ( >=media-libs/alsa-lib-1.0.14a )
	pulseaudio? (
		media-libs/libcanberra
		media-libs/libpulse
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	# TODO: upstream
	"${FILESDIR}/${PN}-23.04.2-autostart_disable.patch"
	# Pending: https://invent.kde.org/multimedia/kmix/-/merge_requests/29
	"${FILESDIR}/${PN}-24.12.2-revert-kcm_pulseaudio-dep.patch"
	# Regressed in: https://invent.kde.org/multimedia/kmix/-/merge_requests/32
	"${FILESDIR}/${PN}-25.03.90-revert-sndio-automagic.patch"
)

src_configure() {
	local mycmakeargs=(
		# XXX: sndio is maybe automagic since 5075cc9502b2768471fd917671fd98bfe5b877cc
		$(cmake_use_find_package alsa ALSA)
		$(cmake_use_find_package pulseaudio Canberra)
		$(cmake_use_find_package pulseaudio PulseAudio)
	)

	ecm_src_configure
}

pkg_postinst() {
	if use pulseaudio && has_version kde-plasma/plasma-pa; then
		elog "In KDE Plasma, kde-plasma/plasma-pa is the default audio volume handler,"
		elog "therefore, autostart by default was disabled for KMix."
		elog
		elog "Should you prefer to still use kde-apps/kmix instead, do the following:"
		elog " - In system tray, right click on [Show hidden items]"
		elog " - Select [Configure System Tray]"
		elog " - In [Entries],  search for [Audio Volume] and set it to [Disabled]"
		elog
	fi
	elog "KMix will be shown as [Volume Control] after manually starting it once"
	elog "and will be autostarted after configuring such in KMix startup settings."
	xdg_pkg_postinst
}
