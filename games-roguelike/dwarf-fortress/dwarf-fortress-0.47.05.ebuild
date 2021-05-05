# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic optfeature prefix toolchain-funcs

MY_PV=$(ver_rs 0- _ "$(ver_cut 2-)")
MY_PN=df
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="The deepest, most intricate simulation of a world that's ever been created."
HOMEPAGE="https://www.bay12games.com/dwarves"
SRC_URI="amd64? ( https://www.bay12games.com/dwarves/${MY_P}_linux.tar.bz2 )
	x86? ( https://www.bay12games.com/dwarves/${MY_P}_linux32.tar.bz2 )"

LICENSE="free-noncomm BSD BitstreamVera"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="debug"

RDEPEND="media-libs/glew:0
	media-libs/libsdl[joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	sys-libs/zlib
	virtual/glu
	x11-libs/gtk+:2"

# Yup, libsndfile, openal and ncurses are only needed at compile-time; the code
# dlopens them at runtime if requested.
DEPEND="${RDEPEND}
	media-libs/libsndfile
	media-libs/openal
	sys-libs/ncurses-compat:5[unicode]"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_PN}_linux"

gamesdir="/opt/${PN}"
QA_PREBUILT="${gamesdir#/}/libs/Dwarf_Fortress"
RESTRICT="strip"

src_unpack() {
	default

	# We're going to modify this file, so let's make a copy
	cp "${FILESDIR}/dwarf-fortress" "${WORKDIR}/dwarf-fortress" || die
}

src_prepare() {
	# for eapply_user
	default

	# We don't want to use any of the bundled libraries
	rm -f libs/*.so* || die
	# This file seems to be missing this import, resulting in a compile error.
	sed -i -e '1i#include <cmath>' g_src/ttf_manager.cpp || die
	# This ensures that our wrapper script properly respects ${EPREFIX}
	hprefixify "${WORKDIR}/dwarf-fortress"
	# These variables are needed by ${FILESDIR}/Makefile.native
	tc-export CXX PKG_CONFIG
	# use the correct debug flag
	use debug && append-cppflags "-DDEBUG"
}

src_compile() {
	emake -f "${FILESDIR}/Makefile.native"
}

src_install() {
	# install data-files and libs
	insinto "${gamesdir}"
	doins -r raw data libs

	# install our wrapper
	dobin "${WORKDIR}/dwarf-fortress"

	# install docs
	dodoc README.linux *.txt

	fperms 755 "${gamesdir}"/libs/Dwarf_Fortress
}

pkg_postinst() {
	elog "System-wide Dwarf Fortress has been installed to ${gamesdir}. This is"
	elog "symlinked to ~/.dwarf-fortress when dwarf-fortress is run."
	elog "For more information on what exactly is replaced, see ${EPREFIX}/usr/bin/dwarf-fortress."
	elog "Note: This means that the primary entry point is ${EPREFIX}/usr/bin/dwarf-fortress."
	elog "Do not run ${gamesdir}/libs/Dwarf_Fortress."

	optfeature "text PRINT_MODE" sys-libs/ncurses[unicode]
	optfeature "audio output" "media-libs/openal media-libs/libsndfile"
	optfeature "OpenGL PRINT_MODE" media-libs/libsdl[opengl]
}
