# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="FFmpeg based thumbnail generator for video files"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	media-video/ffmpeg:0=
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	virtual/pkgconfig
"
