# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kffmpegthumbnailer/kffmpegthumbnailer-1.1.0-r3.ebuild,v 1.4 2015/06/04 19:04:08 kensington Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="KDE thumbnailer based on ffmpegthumbnailer"
HOMEPAGE="http://code.google.com/p/ffmpegthumbnailer/"
SRC_URI="http://ffmpegthumbnailer.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	>=media-video/ffmpegthumbnailer-2
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kdebase-kioslaves)
"

DOCS=( Changelog README )

src_prepare() {
	sed	-e  "/Encoding=UTF-8/d" \
		-i  kffmpegthumbnailer.desktop || die "fixing .desktop file failed"
	kde4-base_src_prepare
}
