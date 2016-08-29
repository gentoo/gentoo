# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

MY_PV=$(replace_all_version_separators _ "$(get_version_component_range 2-)")
MY_PN=df
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="A single-player fantasy game"
HOMEPAGE="http://www.bay12games.com/dwarves"
SRC_URI="amd64? ( http://www.bay12games.com/dwarves/${MY_P}_linux.tar.bz2 )
	x86? ( http://www.bay12games.com/dwarves/${MY_P}_linux32.tar.bz2 )"

LICENSE="free-noncomm BSD BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
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
	sys-libs/ncurses[unicode]
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}_linux

gamesdir="/opt/${PN}"
QA_PREBUILT="${gamesdir#/}/libs/Dwarf_Fortress"
RESTRICT="strip"

src_prepare() {
	rm -f libs/*.so* || die
	sed -i -e '1i#include <cmath>' g_src/ttf_manager.cpp || die
	default
}

src_configure() {
	tc-export CXX PKG_CONFIG
	CXXFLAGS+=" -D$(use debug || echo N)DEBUG"
}

src_compile() {
	emake -f "${FILESDIR}/Makefile.native"
	sed -e "s:^gamesdir=.*:gamesdir=${gamesdir}:" "${FILESDIR}/dwarf-fortress" > dwarf-fortress || die
}

src_install() {
	# install data-files and libs
	insinto "${gamesdir}"
	doins -r raw data libs

	# install our wrapper
	dobin dwarf-fortress

	# install docs
	dodoc README.linux *.txt

	fperms 755 "${gamesdir}"/libs/Dwarf_Fortress
}

pkg_postinst() {
	elog "System-wide Dwarf Fortress has been installed to ${gamesdir}. This is"
	elog "symlinked to ~/.dwarf-fortress when dwarf-fortress is run."
	elog "For more information on what exactly is replaced, see /usr/bin/dwarf-fortress."
	elog "Note: This means that the primary entry point is /usr/bin/dwarf-fortress."
	elog "Do not run ${gamesdir}/libs/Dwarf_Fortress."
	elog
	elog "Optional runtime dependencies:"
	elog "Install sys-libs/ncurses[unicode] for [PRINT_MODE:TEXT]"
	elog "Install media-libs/openal and media-libs/libsndfile for audio output"
	elog "Install media-libs/libsdl[opengl] for the OpenGL PRINT_MODE settings"
}
