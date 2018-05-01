# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit desktop python-r1

DESCRIPTION="A little puzzle game, similar to the famous Bejeweled or Zookeeper"
HOMEPAGE="http://sam.zoy.org/projects/monsterz/"
SRC_URI="http://sam.zoy.org/projects/monsterz/${P}.tar.gz"

LICENSE="GPL-1+ LGPL-2+ WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygame[${PYTHON_USEDEP}]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eapply \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-64bit.patch \
		"${FILESDIR}"/${P}-blit.patch
	sed -i \
		-e "s:GENTOO_DATADIR:/usr/share/${PN}:" \
		monsterz.py || die "sed failed"
	rm Makefile || die
}

src_install() {
	insinto /usr/share/${PN}
	doins -r graphics sound
	newbin monsterz.py ${PN}
	newicon graphics/icon.png ${PN}.png
	make_desktop_entry ${PN} Monsterz
	einstalldocs
	python_replicate_script "${ED%/}"/usr/bin/monsterz
}
