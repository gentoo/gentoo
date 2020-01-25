# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KDE_RELEASE_SERVICE="true"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Simple music player by KDE"
HOMEPAGE="https://community.kde.org/Elisa"

LICENSE="LGPL-3+"
SLOT="5"
KEYWORDS="~amd64 ~arm64"
IUSE="mpris semantic-desktop vlc"

BDEPEND="sys-devel/gettext"
DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtmultimedia-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
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
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package mpris KF5DBusAddons)
		$(cmake_use_find_package semantic-desktop KF5Baloo)
		$(cmake_use_find_package vlc LIBVLC)
	)

	ecm_src_configure
}
