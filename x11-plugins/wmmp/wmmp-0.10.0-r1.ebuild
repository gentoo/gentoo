# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${P/wm/WM}

DESCRIPTION="Window Maker dock app client for mpd (Music Player Daemon)"
HOMEPAGE="https://github.com/yogsothoth/wmmp"
SRC_URI="mirror://sourceforge/musicpd/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 sparc x86"

RDEPEND="x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

src_configure() {
	econf --with-default-port=6600
}
