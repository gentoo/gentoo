# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCHSET="${P}-patchset"
ECM_HANDBOOK="optional"
PIMMIN=26.04.3
KFMIN=6.29.0
QTMIN=6.11.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Application to manage alarms and other timer based alerts for the desktop"
HOMEPAGE="https://apps.kde.org/kalarm/ https://userbase.kde.org/KAlarm"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/kde/${PATCHSET}.tar.xz"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="6"
KEYWORDS="amd64 arm64"
IUSE="+pim speech vlc X"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,X?]
	>=kde-apps/kidentitymanagement-${PIMMIN}:6=
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kmime-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X?]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	pim? (
		>=kde-apps/akonadi-${PIMMIN}:6=
		>=kde-apps/akonadi-contacts-${PIMMIN}:6=
		>=kde-apps/akonadi-mime-${PIMMIN}:6=
		>=kde-apps/kmailtransport-${PIMMIN}:6=
	)
	speech? ( >=dev-libs/ktextaddons-2.0.2:6=[speech] )
	vlc? ( =media-video/vlc-3*:= )
	!vlc? ( >=media-video/mpv-0.37.0:=[libmpv] )
"
RDEPEND="${DEPEND}
	pim? ( >=kde-apps/kdepim-runtime-${PIMMIN}:6 )
"

PATCHES=(
	"${WORKDIR}/${PATCHSET}" # in 26.12; KDE-bug 529081
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_LIBMPV=$(usex !vlc)
		-DENABLE_LIBVLC=$(usex vlc)
		-DENABLE_AKONADI_PLUGIN=$(usex pim)
		$(cmake_use_find_package speech KF6TextEditTextToSpeech)
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}

src_test() {
	# LC_TIME bug 665626, 857012
	# TZ bug https://bugs.kde.org/show_bug.cgi?id=445734
	LC_TIME="C" TZ=UTC ecm_src_test
}
