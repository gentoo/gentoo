# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix optfeature toolchain-funcs desktop readme.gentoo-r1

MY_PV=$(ver_rs 1- _ "$(ver_cut 2-)")
MY_P=df_${MY_PV}

DESCRIPTION="A single-player fantasy game"
HOMEPAGE="https://www.bay12games.com/dwarves"
SRC_URI="amd64? ( https://www.bay12games.com/dwarves/${MY_P}_linux.tar.bz2 )
	x86? ( https://www.bay12games.com/dwarves/${MY_P}_linux32.tar.bz2 )"
S="${WORKDIR}"/df_linux

PATCHES=(
	"${FILESDIR}/${P}-fix-cmath.patch"
	"${FILESDIR}/${P}-segfault-fix-729002.patch"
)

LICENSE="free-noncomm BSD BitstreamVera"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="debug"

RDEPEND="media-libs/glew:0=
	media-libs/libsdl[joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	sys-libs/zlib:=
	virtual/glu
	x11-libs/gtk+:2"
# Yup, libsndfile, openal and ncurses are only needed at compile-time; the code
# dlopens them at runtime if requested.
DEPEND="${RDEPEND}
	media-libs/libsndfile
	media-libs/openal
	sys-libs/ncurses-compat:5[unicode]
	virtual/pkgconfig"
BDEPEND="virtual/pkgconfig"

QA_PREBUILT="/opt/${PN}/libs/Dwarf_Fortress"

DOC_CONTENTS="Dwarf Fortress has been installed to /opt/${PN}. This is
	symlinked to ~/.dwarf-fortress when dwarf-fortress is run.
	For more information on what exactly is replaced, see ${EROOT}/usr/bin/dwarf-fortress.
	Note: This means that the primary entry point is ${EROOT}/usr/bin/dwarf-fortress.
	Do not run /opt/${PN}/libs/Dwarf_Fortress."

src_prepare() {
	# fix line endings so the patches can apply properly
	sed -i \
		-e 's/\r$//' \
		g_src/ttf_manager.cpp \
		g_src/music_and_sound_openal.cpp \
		|| die

	default

	# dwarf fortress includes prebuilt libraries such as libstdc++ we won't use
	rm -f libs/*.so* || die
}

src_configure() {
	hprefixify "${WORKDIR}/dwarf-fortress"

	CXXFLAGS+=" -D$(use debug || echo N)DEBUG"
}

src_compile() {
	tc-export CXX PKG_CONFIG

	emake -f "${FILESDIR}/Makefile.native"
}

src_install() {
	insinto /opt/${PN}
	doins -r raw data libs

	dobin ${FILESDIR}/dwarf-fortress

	readme.gentoo_create_doc
	dodoc README.linux *.txt

	fperms 755 /opt/${PN}/libs/Dwarf_Fortress

	make_desktop_entry dwarf-fortress "Dwarf Fortress" "dwarf-fortress" Game
}

pkg_postinst() {
	readme.gentoo_print_elog

	optfeature "text PRINT_MODE" sys-libs/ncurses-compat:5[unicode]
	optfeature "audio output" "media-libs/openal media-libs/libsndfile"
	optfeature "OpenGL PRINT_MODE" media-libs/libsdl[opengl]
}
