# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop python-single-r1

DESCRIPTION="Puzzle game similar to the famous Bejeweled or Zookeeper"
HOMEPAGE="http://sam.zoy.org/projects/monsterz/"
SRC_URI="
	http://sam.zoy.org/projects/monsterz/${P/_p*}.tar.gz
	mirror://debian/pool/main/${P::1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz"
S="${WORKDIR}/${P/_p*}"

LICENSE="GPL-1+ LGPL-2+ WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pygame[${PYTHON_USEDEP}]')
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[mod]"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${WORKDIR}"/debian/patches
)

src_prepare() {
	default

	sed "/sharedir/s|= dirname.*|= \"${EPREFIX}/usr/share/${PN}\"|" \
		-i monsterz.py || die
	python_fix_shebang monsterz.py

	rm Makefile || die
}

src_install() {
	newbin ${PN}{.py,}

	insinto /usr/share/${PN}
	doins -r graphics sound

	newicon graphics/icon.png ${PN}.png
	make_desktop_entry ${PN} ${PN^}

	einstalldocs
}
