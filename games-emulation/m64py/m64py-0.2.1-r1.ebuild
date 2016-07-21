# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

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
	>=games-emulation/mupen64plus-core-2.0-r1:0/2"

python_prepare_all() {
	# set the correct search path
	cat >> src/m64py/platform.py <<-_EOF_
		SEARCH_DIRS = ["/usr/$(get_libdir)/mupen64plus"]
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

pkg_postinst() {
	local vr
	for vr in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 0.2.1-r1 ${vr}; then
			ewarn
			ewarn "Starting with mupen64plus-2.0-r1, the plugin install path has changed."
			ewarn "In order for m64py to find mupen64plus, you will either need to set"
			ewarn "new paths in configuration dialog or remove your configuration file."
			ewarn "The new paths are:"
			ewarn
			ewarn " Library file:      /usr/$(get_libdir)/libmupen64plus.so.2.0.0"
			ewarn " Plugins directory: /usr/$(get_libdir)/mupen64plus"
			ewarn " Data directory:    /usr/share/mupen64plus"
		fi
	done

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
