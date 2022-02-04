# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Networked Puzzle Bubble clone"
HOMEPAGE="http://freshmeat.net/projects/pengupop"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,video]
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

src_compile() {
	emake LIBS=-lm #497196
}

src_install() {
	default

	doicon pengupop.png
	make_desktop_entry ${PN} Pengupop
}
