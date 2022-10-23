# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools edos2unix prefix toolchain-funcs

MYP=Img-${PV}-Source

DESCRIPTION="Adds a lot of image formats to Tcl/Tk"
HOMEPAGE="http://tkimg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/$(ver_cut 1-2)/${PN}%20${PV}/${MYP}.tar.gz
	https://dev.gentoo.org/~tupone/distfiles/${PN}-1.4.7-patchset-1.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc test static-libs"

RDEPEND="
	dev-lang/tk:=
	>=dev-tcltk/tcllib-1.11
	media-libs/tiff:0=
	>=media-libs/libpng-1.6:0=
	>=sys-libs/zlib-1.2.7:=
	x11-libs/libX11
	virtual/jpeg:="
DEPEND="${RDEPEND}
	test? (
		x11-apps/xhost
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )"

# Fails tests
RESTRICT="test"

S="${WORKDIR}/Img-${PV}"

PATCHES=(
	"${WORKDIR}"/${PN}-1.4.7-tclconfig.patch
	"${WORKDIR}"/${PN}-1.4.7-jpeg.patch
	"${WORKDIR}"/${PN}-1.4.7-zlib.patch
	"${WORKDIR}"/${PN}-1.4.7-png.patch
	"${WORKDIR}"/${PN}-1.4.7-tiff.patch
	"${FILESDIR}"/${PN}-1.4-jpeg-9.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	edos2unix \
		libjpeg/jpegtclDecls.h \
		libjpeg/Makefile.in \
		zlib/Makefile.in \
		zlib/zlibtcl.decls \
		zlib/zlibtclDecls.h \
		libpng/Makefile.in \
		libpng/pngtclDecls.h \
		libtiff/Makefile.in \
		libtiff/tifftclDecls.h \
		libtiff/tifftclStubInit.c \
		tiff/tiff.c \
		jpeg/jpeg.c

	default

	find . -name configure -delete || die
	find compat/{libjpeg,libpng,zlib,libtiff} -delete || die

	eautoreconf
	for dir in zlib libpng libtiff libjpeg base bmp gif ico jpeg pcx pixmap png\
		ppm ps sgi sun tga tiff window xbm xpm dted raw flir ; do
		(cd ${dir}; eautoreconf)
	done

	eprefixify */*.h
	tc-export AR
}

src_install() {
	local l bl

	emake \
		DESTDIR="${D}" \
		INSTALL_ROOT="${D}" \
		install

	if ! use static-libs; then
		find "${ED}"/usr/$(get_libdir)/ -type f -name "*\.a" -delete || die
	fi

	# Make library links
	for l in "${ED}"/usr/lib*/Img*/*tcl*.so; do
		bl=$(basename ${l})
		dosym Img${PV}/${bl} /usr/$(get_libdir)/${bl}
	done

	dodoc ChangeLog README Reorganization.Notes.txt changes ANNOUNCE

	if use doc; then
		docompress -x usr/share/doc/${PF}/demo.tcl
		dodoc demo.tcl
		docinto html
		dodoc -r doc/*
	fi
}
