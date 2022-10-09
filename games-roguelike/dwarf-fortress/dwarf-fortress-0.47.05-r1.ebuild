# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic optfeature prefix readme.gentoo-r1 toolchain-funcs

MY_P="df_$(ver_rs 1- _ $(ver_cut 2-))"

DESCRIPTION="Single-player fantasy game"
HOMEPAGE="https://www.bay12games.com/dwarves/"
SRC_URI="
	amd64? ( https://www.bay12games.com/dwarves/${MY_P}_linux.tar.bz2 )
	x86? ( https://www.bay12games.com/dwarves/${MY_P}_linux32.tar.bz2 )
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}/df_linux"

LICENSE="free-noncomm BSD BitstreamVera"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="debug gui"

RDEPEND="
	dev-libs/glib:2
	media-libs/glew:0=
	media-libs/libglvnd[X]
	media-libs/libsdl[joystick,opengl,video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	sys-libs/zlib:=
	virtual/glu
	gui? ( x11-libs/gtk+:2 )"
# libsndfile, openal and ncurses are only needed at compile-time,
# optfeature through dlopen() at runtime if requested
DEPEND="
	${RDEPEND}
	media-libs/libsndfile
	media-libs/openal
	sys-libs/ncurses"
BDEPEND="virtual/pkgconfig"

QA_PREBUILT="opt/${PN}/libs/Dwarf_Fortress"

PATCHES=(
	"${FILESDIR}"/${P}-missing-cmath.patch
	"${FILESDIR}"/${P}-ncurses6.patch
	"${FILESDIR}"/${P}-nogtk.patch
	"${FILESDIR}"/${P}-segfault-fixes.patch
)

src_prepare() {
	default

	# remove prebuilt libraries that are provided by the system
	rm libs/*.so* || die
}

src_compile() {
	tc-export CXX PKG_CONFIG

	# -DDEBUG is recognized to give additional debug output
	append-cppflags -D$(usev !debug N)DEBUG

	emake -f "${FILESDIR}"/Makefile.native HAVE_GTK=$(usex gui 1 0)
}

src_install() {
	insinto /opt/${PN}
	doins -r data libs raw

	fperms +x /opt/${PN}/libs/Dwarf_Fortress

	dobin "$(prefixify_ro "${FILESDIR}"/dwarf-fortress)"

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry dwarf-fortress "Dwarf Fortress"

	dodoc README.linux *.txt

	local DOC_CONTENTS="
		Dwarf Fortress has been installed to ${EPREFIX}/opt/${PN}. This is
		symlinked to ~/.${PN} when ${PN} is run. For more information on what
		exactly is replaced, see ${EPREFIX}/usr/bin/${PN}. Note: This means
		that the primary entry point is ${EPREFIX}/usr/bin/${PN}, do not run
		${EPREFIX}/opt/${PN}/libs/Dwarf_Fortress."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	optfeature "text PRINT_MODE" sys-libs/ncurses
	optfeature "audio output" "media-libs/openal media-libs/libsndfile[-minimal]"
}
