# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Unified media experience for any device capable of running KDE Plasma"
HOMEPAGE="https://community.kde.org/Plasma/Plasma_Media_Center"
SRC_URI="mirror://kde/stable/plasma-mediacenter/${PV}/${P}.tar.xz"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm x86"
IUSE="semantic-desktop"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	media-libs/taglib
	semantic-desktop? (
		>=kde-frameworks/baloo-${KFMIN}:5
		>=kde-frameworks/kfilemetadata-${KFMIN}:5
	)
"
RDEPEND="${DEPEND}
	>=dev-qt/qtmultimedia-${QTMIN}:5[qml]
	>=kde-plasma/plasma-workspace-5.15.5:5
	!media-video/plasma-mediacenter:0
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package semantic-desktop KF5Baloo)
	)

	ecm_src_configure
}
