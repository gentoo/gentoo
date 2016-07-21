# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="Application to edit and synchronize lyrics with karaoke songs in various formats"
HOMEPAGE="http://www.ulduzsoft.com/linux/karaoke-lyrics-editor/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libav qt5"

RDEPEND="
	dev-libs/openssl:0
	media-libs/libsdl[sound]
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	libav? ( media-video/libav:= )
	!libav? ( media-video/ffmpeg:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.11-libav.patch"
	"${FILESDIR}/${PN}-2.1-ffmpeg3.patch"
	"${FILESDIR}/${PN}-2.1-qt55.patch"
)

src_configure() {
	if use qt5; then
		eqmake5 "${PN}.pro"
	else
		eqmake4 "${PN}.pro"
	fi
}

src_install() {
	dodoc Changelog
	dobin bin/${PN}
	doicon packages/${PN}.png
	make_desktop_entry ${PN} 'Karaoke Lyrics Editor'
}
