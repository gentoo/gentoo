# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Convert Hewlett-Packard's HP-GL plotter language to other graphics formats"
HOMEPAGE="https://www.gnu.org/software/hp2xx/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg png tiff X"

RDEPEND="
	jpeg? ( virtual/jpeg )
	png? (
		media-libs/libpng:=
		sys-libs/zlib
	)
	tiff? ( media-libs/tiff:= )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/${P}-r1.patch
	"${FILESDIR}"/${P}-docbuild.patch
)

src_prepare() {
	default
	cp -v makes/generic.mak sources/Makefile || die
}

src_configure() {
	export PREVIEWER="no_prev"
	export EX_SRC=
	export EX_OBJ=
	export EX_DEFS=-DUNIX
	export ALL_LIBS=-lm

	use jpeg && \
		EX_SRC+=" to_jpg.c" \
		EX_OBJ+=" to_jpg.o" \
		EX_DEFS+=" -DJPG" \
		ALL_LIBS+=" -ljpeg"
	use png && \
		EX_SRC+=" png.c to_png.c" \
		EX_OBJ+=" png.o to_png.o" \
		EX_DEFS+=" -DPNG" \
		ALL_LIBS+=" -lpng"
	use tiff && \
		EX_SRC+=" to_tif.c" \
		EX_OBJ+=" to_tif.o" \
		EX_DEFS+=" -DTIF" \
		ALL_LIBS+=" -ltiff"
	use X && \
		PREVIEWER="to_x11" \
		EX_DEFS="-DHAS_UNIX_X11" \
		ALL_LIBS+=" -lX11"

	tc-export CC
}

src_compile() {
	emake -C sources all
}

src_install() {
	dodir \
		/usr/bin \
		/usr/share/info \
		/usr/share/man/man1

	emake \
		prefix="${ED}"/usr \
		mandir="${ED}"/usr/share/man \
		infodir="${ED}"/usr/share/info \
		install
}
