# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop python-single-r1

DESCRIPTION="Traditional and challenging 2D platformer game with a slight rotational twist"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${PN}_b$(ver_rs 1- '').zip
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}/${PN}"

LICENSE="BitstreamVera CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pygame[${PYTHON_USEDEP}]')
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis]"
BDEPEND="
	${PYTHON_DEPS}
	app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-check_for_joystick_axes_not_null.patch
	"${FILESDIR}"/${P}-initialize_only_required_pygame_modules.patch
	"${FILESDIR}"/${P}-python3.patch
)

src_prepare() {
	default

	sed -i "/libdir =/s|= .*|= \"${EPREFIX}/usr/share/${PN}/lib\"|" run_game.py || die
	python_fix_shebang run_game.py

	rm data/pictures/Thumbs.db || die
}

src_install() {
	newbin run_game.py ${PN}

	insinto /usr/share/${PN}
	doins -r data lib

	dodoc README.txt changelog.txt

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Which Way Is Up?"
}
