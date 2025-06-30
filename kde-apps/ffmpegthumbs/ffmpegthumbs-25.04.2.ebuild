# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="FFmpeg based thumbnail generator for video files"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	media-video/ffmpeg:0=
"
RDEPEND="${DEPEND}
	!<kde-apps/ffmpegthumbs-23.08.5-r1:5
	!kde-apps/ffmpegthumbs-common
"
BDEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	virtual/pkgconfig
"
