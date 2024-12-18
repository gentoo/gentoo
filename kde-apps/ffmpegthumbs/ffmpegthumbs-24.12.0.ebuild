# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="FFmpeg based thumbnail generator for video files"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	media-video/ffmpeg:0=
"
RDEPEND="${DEPEND}
	>=kde-apps/${PN}-common-${PV}
"
BDEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	virtual/pkgconfig
"

# Shipped by kde-apps/ffmpegthumbs-common package for shared use w/ SLOT 5
ECM_REMOVE_FROM_INSTALL=(
	/usr/share/config.kcfg/ffmpegthumbnailersettings5.kcfg
	/usr/share/metainfo/org.kde.ffmpegthumbs.metainfo.xml
)
