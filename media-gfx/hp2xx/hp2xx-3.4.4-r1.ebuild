# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils base

DESCRIPTION="Versatile tool to convert Hewlett-Packard's HP-GL plotter language into other graphics formats"
HOMEPAGE="https://www.gnu.org/software/hp2xx/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X jpeg png tiff"

RDEPEND="
	png? ( media-libs/libpng sys-libs/zlib )
	tiff? ( media-libs/tiff )
	jpeg? ( virtual/jpeg )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	sys-apps/texinfo"

PATCHES=(  "${FILESDIR}"/${P}-r1.patch
	"${FILESDIR}"/${P}-docbuild.patch )

src_prepare() {
	base_src_prepare
	cp -v makes/generic.mak sources/Makefile || die
}

src_compile() {
	cd "${S}/sources" || die
	export PREVIEWER="no_prev"
	export EX_SRC=
	export EX_OBJ=
	export EX_DEFS=-DUNIX
	export ALL_LIBS=-lm
	use X && \
		PREVIEWER="to_x11" \
		EX_DEFS="-DHAS_UNIX_X11" \
		ALL_LIBS="${ALL_LIBS} -lX11"
	use jpeg && \
		EX_SRC="${EX_SRC} to_jpg.c" \
		EX_OBJ="${EX_OBJ} to_jpg.o" \
		EX_DEFS="${EX_DEFS} -DJPG" \
		ALL_LIBS="${ALL_LIBS} -ljpeg"
	use png && \
		EX_SRC="${EX_SRC} png.c to_png.c" \
		EX_OBJ="${EX_OBJ} png.o to_png.o" \
		EX_DEFS="${EX_DEFS} -DPNG" \
		ALL_LIBS="${ALL_LIBS} -lpng"
	use tiff && \
		EX_SRC="${EX_SRC} to_tif.c" \
		EX_OBJ="${EX_OBJ} to_tif.o" \
		EX_DEFS="${EX_DEFS} -DTIF" \
		ALL_LIBS="${ALL_LIBS} -ltiff"
	emake all
}

src_install() {
	dodir /usr/bin /usr/share/info /usr/share/man/man1

	make prefix="${D}/usr" \
		mandir="${D}/usr/share/man" \
		infodir="${D}/usr/share/info" \
		install || die
}
