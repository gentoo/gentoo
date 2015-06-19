# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/llpp/llpp-13_p20121123.ebuild,v 1.7 2013/07/13 23:16:59 xmw Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="a graphical PDF viewer which aims to superficially resemble less(1)"
HOMEPAGE="http://repo.or.cz/w/llpp.git"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-libs/freetype
	media-libs/jbig2dec
	media-libs/openjpeg:0
	virtual/jpeg
	x11-libs/libX11
	x11-misc/xsel"
DEPEND="${RDEPEND}
	=app-text/mupdf-1.1_p20121127
	dev-lang/ocaml[ocamlopt]
	dev-ml/lablgl[glut]"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-11-WM_CLASS.patch
}

src_compile() {
	ocaml str.cma keystoml.ml < KEYS > help.ml || die
	printf 'let version ="%s";;\n' ${PV} >> help.ml || die

	local myccopt="$(freetype-config --cflags) -O -include ft2build.h -D_GNU_SOURCE"
	local mycclib="-lfitz -lz -ljpeg -lopenjpeg -ljbig2dec -lfreetype -lX11 -lpthread"
	ocamlopt.opt -c -o link.o -ccopt "${myccopt}" link.c || die
	ocamlopt.opt -c -o help.cmx help.ml || die
	ocamlopt.opt -c -o wsi.cmi wsi.mli || die
	ocamlopt.opt -c -o wsi.cmx wsi.ml || die
	ocamlopt.opt -c -o parser.cmx parser.ml || die
	ocamlopt.opt -c -o main.cmx -I +lablGL main.ml || die
	ocamlopt.opt -o llpp -I +lablGL \
		str.cmxa unix.cmxa lablgl.cmxa link.o \
	    -cclib "${mycclib}" help.cmx parser.cmx wsi.cmx main.cmx || die
}

src_install() {
	dobin ${PN}
	dodoc KEYS README Thanks fixme
}
