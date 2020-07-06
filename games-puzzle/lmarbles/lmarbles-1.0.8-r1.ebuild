# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="puzzle game inspired by Atomix and written in SDL"
HOMEPAGE="http://lgames.sourceforge.net/LMarbles/"
SRC_URI="https://download.sourceforge.net/lgames/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	mv configure.{in,ac}
	rm *.m4
	eautoreconf
}

src_install() {
	default
	dodoc src/manual/*
}
