# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DATA_PV="0.8"

DESCRIPTION="Port of Abuse by Crack Dot Com"
HOMEPAGE="https://github.com/Xenoveritas/abuse"
SRC_URI="https://github.com/Xenoveritas/abuse/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	http://abuse.zoy.org/raw-attachment/wiki/download/${PN}-${DATA_PV}.tar.gz"

LICENSE="GPL-2 public-domain WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-libs/libsdl2-2.0.3[sound,video]
	media-libs/sdl2-mixer[midi,wav]"

RDEPEND="${DEPEND}"

src_prepare() {
	ln -snf ../../${PN}-${DATA_PV}/data/{music,sfx} data/ || die
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	doicon -s 32 doc/${PN}.png
	make_desktop_entry abuse Abuse
}
