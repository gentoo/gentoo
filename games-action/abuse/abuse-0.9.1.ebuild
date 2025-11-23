# Copyright 1999-2022 Gentoo Authors
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
	media-libs/sdl2-mixer[midi,wav]
"
RDEPEND="${DEPEND}"

src_install() {
	cmake_src_install

	cp -r ../${PN}-${DATA_PV}/data/{music,sfx} "${ED}"/usr/share/games/abuse/ || die
	cp -r ../${PN}-${DATA_PV}/data/addon/{aliens,claudio,leon,newart,twist} "${ED}"/usr/share/games/abuse/addon/ || die
	cp -r ../${PN}-${DATA_PV}/data/levels/frabs* "${ED}"/usr/share/games/abuse/levels/ || die

	doicon data/freedesktop/com.github.Xenoveritas.abuse.png
	domenu data/freedesktop/com.github.Xenoveritas.abuse.desktop
	insinto /usr/share/metainfo
	doins data/freedesktop/com.github.Xenoveritas.abuse.appdata.xml
}
