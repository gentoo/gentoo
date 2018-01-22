# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit scons-utils games

DESCRIPTION="An accuracy-focused Gameboy / Gameboy Color emulator"
HOMEPAGE="https://sourceforge.net/projects/gambatte"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[X,sound,joystick,video]
	sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

fix_scons() {
	local i
	for i; do
		cat >> $i << END
import os
import SCons.Util

if os.environ.has_key('AR'):
	env['AR'] = os.environ['AR']
if os.environ.has_key('RANLIB'):
	env['RANLIB'] = os.environ['RANLIB']
if os.environ.has_key('CC'):
	env['CC'] = os.environ['CC']
if os.environ.has_key('CFLAGS'):
	env['CCFLAGS'] += SCons.Util.CLVar(os.environ['CFLAGS'])
if os.environ.has_key('CXX'):
	env['CXX'] = os.environ['CXX']
if os.environ.has_key('CXXFLAGS'):
	env['CXXFLAGS'] += SCons.Util.CLVar(os.environ['CXXFLAGS'])
if os.environ.has_key('CPPFLAGS'):
	env['CCFLAGS'] += SCons.Util.CLVar(os.environ['CPPFLAGS'])
if os.environ.has_key('LDFLAGS'):
	env['LINKFLAGS'] += SCons.Util.CLVar(os.environ['LDFLAGS'])
END
	done
}

src_prepare() {
	# Fix zlib/minizip build error
	sed -i \
		-e '1i#define OF(x) x' \
		libgambatte/src/file/unzip/{unzip,ioapi}.h \
		|| die "sed iompi.h failed"

	fix_scons {gambatte_sdl,libgambatte}/SConstruct
}

src_compile() {
	# build core library
	cd "${S}"/libgambatte || die
	escons

	# build sdl frontend
	cd "${S}"/gambatte_sdl || die
	escons
}

src_install() {
	dogamesbin gambatte_sdl/gambatte_sdl

	dodoc README changelog

	prepgamesdirs
}
