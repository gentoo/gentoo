# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="GTK program to rip CD audio tracks to Ogg, MP3 or FLAC"
HOMEPAGE="https://sourceforge.net/projects/ripperx"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P/x/X}.tar.gz"

S="${WORKDIR}/${P/x/X}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="
	media-libs/id3lib
	media-sound/cdparanoia
	media-sound/lame
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-ceilf-underlink.patch
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-pkgconfig.patch
	"${FILESDIR}"/${P}-incompatible-pointer.patch
)

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	doicon src/xpms/ripperX-icon.xpm
	make_desktop_entry ripperX ripperX ripperX-icon
}
