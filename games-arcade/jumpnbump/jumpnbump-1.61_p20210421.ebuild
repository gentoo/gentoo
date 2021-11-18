# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop python-single-r1 toolchain-funcs

MY_COMMIT="73c5fe86fd831dec45a22077e8d63dd2b6a6349e"

DESCRIPTION="Funny multiplayer game about cute little fluffy bunnies"
HOMEPAGE="https://libregames.gitlab.io/jumpnbump"
SRC_URI="https://gitlab.com/LibreGames/jumpnbump/-/archive/${MY_COMMIT}/${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"
REQUIRED_USE="gui? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	app-arch/bzip2:=
	media-libs/libsdl2[joystick,sound,video]
	media-libs/sdl2-mixer[mod]
	media-libs/sdl2-net
	sys-libs/zlib:="
RDEPEND="
	${DEPEND}
	gui? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pillow[${PYTHON_USEDEP}]
			dev-python/pygobject[${PYTHON_USEDEP}]
		')
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
	)"
BDEPEND="gui? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.61-ranlib.patch
)

pkg_setup() {
	use gui && python-single-r1_pkg_setup
}

src_compile() {
	tc-export AR CC RANLIB

	emake PREFIX="${EPREFIX}"/usr

	if use gui; then
		emake PREFIX="${EPREFIX}"/usr jnbmenu
		python_fix_shebang menu/jumpnbump_menu.py
	fi
}

src_install() {
	emake PREFIX="${ED}"/usr install

	use gui && emake -C menu PREFIX="${ED}"/usr install

	doicon dist/${PN}.png
	rm "${ED}"/usr/share/icons/${PN}.png || die

	einstalldocs
}
