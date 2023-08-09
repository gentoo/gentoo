# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Simple music player by KDE"
HOMEPAGE="https://elisa.kde.org/ https://apps.kde.org/elisa/"

LICENSE="LGPL-3+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="mpris semantic-desktop +vlc"

RESTRICT="test"

BDEPEND="sys-devel/gettext"
DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kfilemetadata-${KFMIN}:5[taglib]
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	mpris? (
		>=dev-qt/qtdbus-${QTMIN}:5
		>=kde-frameworks/kdbusaddons-${KFMIN}:5
	)
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:5 )
	vlc? ( media-video/vlc:= )
	!vlc? ( >=dev-qt/qtmultimedia-${QTMIN}:5[gstreamer] )
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package mpris KF5DBusAddons)
		$(cmake_use_find_package semantic-desktop KF5Baloo)
		$(cmake_use_find_package vlc LIBVLC)
	)

	ecm_src_configure
}
