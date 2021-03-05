# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit python-single-r1 flag-o-matic toolchain-funcs

DESCRIPTION="A funny multiplayer game about cute little fluffy bunnies"
HOMEPAGE="https://libregames.gitlab.io/jumpnbump"
SRC_URI="https://gitlab.com/LibreGames/${PN}/uploads/95acdae2a232513f068e260977371dcf/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

REQUIRED_USE="gtk? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	media-libs/sdl2-mixer[mod]
	media-libs/libsdl2
	media-libs/sdl2-net
"
RDEPEND="
	${DEPEND}
	gtk? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pygobject[${PYTHON_USEDEP}]
		')
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
	)
"

src_compile() {
	tc-export AR CC RANLIB

	append-flags -fcommon

	emake PREFIX="${EPREFIX}/usr"
	use gtk && emake PREFIX="${EPREFIX}/usr" jnbmenu
}

src_install() {
	emake PREFIX="${ED}/usr" install
	if use gtk; then
		emake -C menu PREFIX="${ED}/usr" install
		python_doscript "${ED}/usr/bin/jumpnbump-menu"
	fi
}
