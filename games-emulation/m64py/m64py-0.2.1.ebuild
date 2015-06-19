# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/m64py/m64py-0.2.1.ebuild,v 1.1 2014/05/08 20:49:22 mgorny Exp $
EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 games

DESCRIPTION="A frontend for Mupen64Plus"
HOMEPAGE="http://m64py.sourceforge.net/"
SRC_URI="mirror://sourceforge/m64py/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 public-domain GPL-2 BSD CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# SDL & libmupen64plus are through ctypes, so they rely on specific ABI
RDEPEND="media-libs/libsdl:0/0[joystick]
	dev-python/PyQt4[opengl,${PYTHON_USEDEP}]
	games-emulation/mupen64plus-core:0/2"

python_prepare_all() {
	# set the correct search path
	cat >> src/m64py/platform.py <<-_EOF_
		SEARCH_DIRS = ["$(games_get_libdir)/mupen64plus"]
_EOF_

	# comment out SDL2 support since our mupen64plus uses SDL1
	sed -e '/from m64py\.SDL2/s:^:#:' \
		-e '/QT2SDL2\[/s:^:#:' \
		-e '/KEYCODE2SCANCODE\[/s:^:#:' \
		-e '/SCANCODE2KEYCODE\[/s:^:#:' \
		-i src/m64py/frontend/keymap.py || die
	sed -e '/--sdl2/d' \
		-e '/SDL2/s:=.*$:= False:' \
		-i src/m64py/opts.py || die

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install \
		--install-scripts="${GAMES_BINDIR}"
}

# games.eclass ABSOLUTELY MUST come last, so we need to clean up the mess
src_prepare() { distutils-r1_src_prepare; }
src_configure() { distutils-r1_src_configure; }
src_compile() { distutils-r1_src_compile; }
src_test() { distutils-r1_src_test; }

src_install() {
	distutils-r1_src_install
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if ! type -P rar >/dev/null && ! type -P unrar >/dev/null; then
		elog
		elog "In order to gain RAR archive support, please install either app-arch/rar"
		elog "or app-arch/unrar."
	fi

	if ! type -P 7z >/dev/null \
			&& ! has_version "dev-python/pylzma[${PYTHON_USEDEP}]"; then
		elog
		elog "In order to gain 7z archive support, please install either app-arch/p7zip"
		elog "or dev-python/pylzma."
	fi
}
