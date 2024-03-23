# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Simple music player by KDE"
HOMEPAGE="https://apps.kde.org/elisa/"

LICENSE="LGPL-3+"
SLOT="6"
KEYWORDS="~amd64"
IUSE="mpris vlc"

RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,sql,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kfilemetadata-${KFMIN}:6[taglib]
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
	mpris? (
		>=dev-qt/qtbase-${QTMIN}:6[dbus]
		>=kde-frameworks/kdbusaddons-${KFMIN}:6
	)
	vlc? ( media-video/vlc:= )
	!vlc? ( >=dev-qt/qtmultimedia-${QTMIN}:6 )
"
RDEPEND="${DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
"
BDEPEND="sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package mpris KF6DBusAddons)
		$(cmake_use_find_package vlc LIBVLC)
	)

	ecm_src_configure
}
