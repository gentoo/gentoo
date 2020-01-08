# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="FFmpeg based thumbnail generator for video files"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="libav"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	libav? ( media-video/libav:= )
	!libav? ( media-video/ffmpeg:0= )
"
RDEPEND="${DEPEND}"
