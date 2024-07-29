# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs readme.gentoo-r1

MY_PN="${PN/-sdl/}"
MY_PV="${PV/e/-5}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Portable redcode simulator's sdl port for core war"
HOMEPAGE="https://corewar.co.uk/pihlaja/pmars-sdl/"
SRC_URI="https://corewar.co.uk/pihlaja/pmars-sdl/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sdl X"

RDEPEND="
	sdl? ( x11-libs/libX11 media-libs/libsdl[video] )
	X? ( x11-libs/libX11 )
	!sdl? ( !X? ( sys-libs/ncurses:0= ) )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-format.patch
)

DOC_CONTENTS="
	There are some macros in /usr/share/pmars/macros
	which you should make accessible to pmars by typing
	export PMARSHOME=/usr/share/pmars/macros\n
"

src_compile() {
	local LIB=""
	export LFLAGS="-x"

	append-cppflags -DEXT94 -DPERMUTATE

	if use sdl ; then
		append-cflags $(sdl-config --cflags)
		append-cppflags -DSDLGRAPHX

		LIB="$(sdl-config --libs)"
	elif use X ; then
		append-cppflags -DXWINGRAPHX

		LIB="$($(tc-getPKG_CONFIG) --libs x11)"
	else
		append-cppflags -DCURSESGRAPHX

		LIB="$($(tc-getPKG_CONFIG) --libs ncurses)"
	fi

	cd src || die

	local programs=(
		asm.c
		cdb.c
		clparse.c
		disasm.c
		eval.c
		global.c
		pmars.c
		sim.c
		pos.c
		str_eng.c
		token.c
	)

	for program in "${programs[@]}" ; do
		einfo "Compiling ${program}"
		$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${program} -c || die
	done

	einfo "Linking with LIB: ${LIB}"
	$(tc-getCC) ${LDFLAGS} *.o ${LIB} -o ${MY_PN} || die
}

src_install() {
	dobin src/${MY_PN}
	doman doc/${MY_PN}.6

	dodoc AUTHORS CONTRIB ChangeLog README doc/redcode.ref
	readme.gentoo_create_doc

	insinto /usr/share/${MY_PN}/warriors
	doins warriors/*

	insinto /usr/share/${MY_PN}/macros
	doins config/*.mac
}

pkg_postinst() {
	readme.gentoo_print_elog
}
