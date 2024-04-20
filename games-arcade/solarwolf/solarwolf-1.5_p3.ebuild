# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit desktop python-single-r1

MY_P="${PN}-$(ver_cut 1-2)"

DESCRIPTION="Action/arcade recreation of SolarFox"
HOMEPAGE="https://www.pygame.org/shredwheat/solarwolf/index.shtml"
SRC_URI="
	http://www.pygame.org/shredwheat/solarwolf/${MY_P}.tar.gz
	mirror://debian/pool/main/s/solarwolf/${MY_P/-/_}+dfsg1-${PV/*_p}.debian.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pygame[${PYTHON_USEDEP}]')
	media-libs/sdl2-image[gif,png]
	media-libs/sdl2-mixer[mod,vorbis]"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${WORKDIR}"/debian/patches
)

src_prepare() {
	default

	sed -e "/CODEDIR = \"/s|= .*|= \"${EPREFIX}/usr/share/${PN}/code\"|" \
		-e "/DATADIR = \"/s|= .*|= \"${EPREFIX}/usr/share/${PN}\"|" \
		-i ${PN}.py || die
	python_fix_shebang ${PN}.py

	# default to windowed given it forces resolution and menus can be invisible
	sed -i '/^display = 1/s/1/0/' code/game.py || die

	rm -r data/.xvpics || die
	gzip -d dist/${PN}.6.gz || die
}

src_install() {
	newbin ${PN}.py ${PN}
	doman dist/${PN}.6

	insinto /usr/share/${PN}
	doins -r code data

	dodoc readme.txt

	newicon data/ship-big.png ${PN}.png
	make_desktop_entry ${PN} SolarWolf
}
