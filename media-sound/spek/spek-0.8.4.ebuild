# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"

inherit wxwidgets xdg

DESCRIPTION="Analyse your audio files by showing their spectrogram"
HOMEPAGE="http://spek.cc/"
SRC_URI="https://github.com/alexkay/spek/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-video/ffmpeg:=
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.4-disable-updates.patch
)

src_configure() {
	setup-wxwidgets unicode
	default
}
