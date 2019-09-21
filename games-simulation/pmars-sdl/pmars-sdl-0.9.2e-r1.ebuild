# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit readme.gentoo-r1 toolchain-funcs

MY_PN="${PN/-sdl/}"
MY_PV="${PV/e/-5}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Portable redcode simulator's sdl port for core war"
HOMEPAGE="http://corewar.co.uk/pihlaja/pmars-sdl/"
SRC_URI="http://corewar.co.uk/pihlaja/pmars-sdl/${MY_P}.tar.gz"

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

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-format.patch )

DOC_CONTENTS="
	There are some macros in /usr/share/pmars/macros
	which you should make accessible to pmars by typing
	export PMARSHOME=/usr/share/pmars/macros\n
"

src_compile() {
	CFLAGS="${CFLAGS} -DEXT94 -DPERMUTATE"
	LFLAGS="-x"

	if use sdl ; then
		CFLAGS="${CFLAGS} -DSDLGRAPHX `sdl-config --cflags`"
		LIB=`sdl-config --libs`
	elif use X ; then
		CFLAGS="${CFLAGS} -DXWINGRAPHX"
		LIB="-L/usr/X11R6/lib -lX11"
	else
		CFLAGS="${CFLAGS} -DCURSESGRAPHX"
		LIB="-lcurses -ltinfo"
	fi

	cd src

	SRC="asm.c
		 cdb.c
		 clparse.c
		 disasm.c
		 eval.c
		 global.c
		 pmars.c
		 sim.c
		 pos.c
		 str_eng.c
		 token.c"

	for x in ${SRC}; do
		einfo "compiling ${x}"
		$(tc-getCC) ${CFLAGS} ${x} -c || die
	done

	echo
	einfo "linking with LIB: ${LIB}"
	$(tc-getCC) ${LDFLAGS} *.o ${LIB} -o ${MY_PN} || die
}

src_install() {
	dobin src/${MY_PN}
	doman doc/${MY_PN}.6

	dodoc AUTHORS CONTRIB ChangeLog README doc/redcode.ref
	readme.gentoo_create_doc

	insinto "/usr/share/${MY_PN}/warriors"
	doins warriors/*

	insinto "/usr/share/${MY_PN}/macros"
	doins config/*.mac
}

pkg_postinst() {
	readme.gentoo_print_elog
}
