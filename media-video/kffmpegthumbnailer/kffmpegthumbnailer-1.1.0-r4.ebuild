# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde4-base

DESCRIPTION="KDE thumbnailer based on ffmpegthumbnailer"
HOMEPAGE="https://github.com/dirkvdb/ffmpegthumbnailer"
SRC_URI="https://ffmpegthumbnailer.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	>=media-video/ffmpegthumbnailer-2.1.0
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kdebase-kioslaves)
"

DOCS=( Changelog README )

src_prepare() {
	sed	-e  "/Encoding=UTF-8/d" \
		-i  kffmpegthumbnailer.desktop || die "fixing .desktop file failed"

	append-cxxflags -std=c++11

	kde4-base_src_prepare
}
