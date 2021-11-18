# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit epatch toolchain-funcs

DESCRIPTION="Display 3D molecules (e.g., proteins) in schematic and detailed representations"
HOMEPAGE="http://www.avatar.se/molscript/"
SRC_URI="${P}.tar.gz"

LICENSE="glut molscript"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	media-libs/freeglut
	media-libs/gd:2=
	media-libs/libpng:0=
	virtual/jpeg:0=
	|| (
		x11-libs/libXmu
		x11-libs/libXext
		x11-libs/libX11
		)"
RDEPEND="${DEPEND}"

RESTRICT="fetch"

pkg_nofetch() {
	elog "Please visit ${HOMEPAGE}"
	elog "and get ${A}."
	elog "Place it into your DISTDIR directory."
}

src_prepare() {
	epatch \
		"${FILESDIR}"/fix-makefile-shared.patch \
		"${FILESDIR}"/${PV}-ldflags.patch \
		"${FILESDIR}"/${PV}-prll.patch \
		"${FILESDIR}"/${PV}-libpng15.patch

	# Provide glutbitmap.h, because freeglut doesn't have it
	cp "${FILESDIR}"/glutbitmap.h "${S}"/clib/ || die

	# Stop an incredibly hacky include
	sed \
		-e 's:<../lib/glut/glutbitmap.h>:"glutbitmap.h":g' \
		-i "${S}"/clib/ogl_bitmap_character.c || die
}

src_compile() {
	# Prefix of programs it links with
	export FREEWAREDIR="${EPREFIX}/usr"

	ln -s Makefile.complete Makefile || die

	emake \
		CC="$(tc-getCC)" \
		COPT="${CFLAGS}"
}

src_install() {
	dobin molscript molauto
	dohtml "${S}"/doc/*.html
}
