# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit autotools-multilib

DESCRIPTION="Open h.265 video codec implementation"
HOMEPAGE="https://github.com/strukturag/libde265"
SRC_URI="https://github.com/strukturag/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug qt5 static-libs cpu_flags_x86_sse"

DEPEND="
	media-libs/libsdl
	virtual/ffmpeg
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-qtbindir.patch" )

src_prepare() {
	sed -ri 's/(PIX_FMT_)/AV_\1/g' sherlock265/VideoDecoder.cc || die
	autotools-multilib_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable static-libs static)
		$(use_enable debug log-info)
		$(use_enable debug log-debug)
		$(use_enable debug log-trace)
		$(use_enable qt5 dec265)
		$(use_enable qt5 sherlock265)
		--disable-silent-rules
		--enable-log-error
	)
	autotools-multilib_src_configure "${myeconfargs[@]}"
}
