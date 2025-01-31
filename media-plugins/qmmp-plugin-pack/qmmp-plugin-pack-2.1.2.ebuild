# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Set of extra plugins for Qmmp"
HOMEPAGE="https://qmmp.ylsoftware.com/"
SRC_URI="https://qmmp.ylsoftware.com/files/${PN}/$(ver_cut 1-2)/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	media-libs/libsamplerate
	media-libs/taglib:=
	=media-sound/qmmp-$(ver_cut 1-2)*
	media-video/ffmpeg:=
"
DEPEND="${RDEPEND}
	dev-lang/yasm
"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	append-ldflags -Wl,-z,noexecstack
	cmake_src_configure
}
