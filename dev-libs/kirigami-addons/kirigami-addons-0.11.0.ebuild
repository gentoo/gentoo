# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP=true
ECM_TEST=true
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm kde.org

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
fi

DESCRIPTION="Visual end user components for Kirigami-based applications"
HOMEPAGE="https://invent.kde.org/libraries/kirigami-addons"

LICENSE="|| ( GPL-2 GPL-3 LGPL-3 ) LGPL-2.1+"
SLOT="5"
IUSE=""

# would profit from VIRTUALX_REQUIRED=test, but then still requires
# org.qt-project.qt.mediaplayer service and fails, bug 911186
RESTRICT="test"

COMMON_DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=kde-plasma/libplasma-${KFMIN}:5
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:5
"
DEPEND="${COMMON_DEPEND}
	test? (
		>=dev-qt/qtmultimedia-${QTMIN}:5[gstreamer,qml]
		media-libs/gst-plugins-base:1.0[ogg,vorbis]
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-good:1.0
		x11-themes/sound-theme-freedesktop
	)
"
