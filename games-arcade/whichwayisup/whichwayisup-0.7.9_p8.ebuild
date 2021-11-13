# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop python-single-r1

DESCRIPTION="Traditional and challenging 2D platformer game with a slight rotational twist"
HOMEPAGE="https://www.oletus.fi/static/whichwayisup/"
SRC_URI="
	https://www.oletus.fi/static/whichwayisup/${PN}_b079.zip
	mirror://debian/pool/main/${P::1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
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
	"${WORKDIR}"/debian/patches
)

src_prepare() {
	# drop Debian specific patch
	rm "${WORKDIR}"/debian/patches/font_path.patch || die

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
