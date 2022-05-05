# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A set of extra plugins for Qmmp"
HOMEPAGE="http://qmmp.ylsoftware.com/"
SRC_URI="https://qmmp.ylsoftware.com/files/${PN}/$(ver_cut 1-2)/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/libsamplerate
	media-libs/taglib
	=media-sound/qmmp-$(ver_cut 1-2)*
	media-video/ffmpeg
"
DEPEND="${RDEPEND}
	dev-lang/yasm
	dev-qt/linguist-tools:5
"

src_configure() {
	append-ldflags -Wl,-z,noexecstack
	cmake_src_configure
}
