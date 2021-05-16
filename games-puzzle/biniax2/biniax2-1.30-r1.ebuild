# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Logic game with arcade and tactics modes"
HOMEPAGE="http://biniax.com/"
SRC_URI="http://mordred.dir.bg/biniax/${P}-fullsrc.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	default

	rm -f data/Thumbs.db
	sed -i \
		-e "s:data/:/usr/share/${PN}/:" \
		desktop/{gfx,snd}.c \
		|| die
	eapply \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-dotfiles.patch
}

src_install() {
	dobin ${PN}
	insinto "/usr/share/${PN}"
	doins -r data/*
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} Biniax-2
}
