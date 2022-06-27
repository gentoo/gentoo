# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools edos2unix prefix toolchain-funcs virtualx

MYP=Img-${PV}-Source

DESCRIPTION="Adds a lot of image formats to Tcl/Tk"
HOMEPAGE="http://tkimg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/1.4/${PN}%20${PV}/${MYP}.tar.gz
	https://dev.gentoo.org/~tupone/distfiles/${PN}-1.4.12-patchset-1.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test static-libs"

RDEPEND="
	dev-lang/tk:=
	dev-tcltk/tcllib
	media-libs/tiff:0=
	media-libs/libpng:0=
	sys-libs/zlib:=
	x11-libs/libX11
	media-libs/libjpeg-turbo:="
DEPEND="${RDEPEND}
	test? (
		x11-apps/xhost
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )"

RESTRICT="!test? ( test )"

S="${WORKDIR}/Img-${PV}"

PATCHES=(
	"${WORKDIR}"/patchset-1
	"${FILESDIR}"/${P}-test.patch
)

src_prepare() {
	edos2unix \
		libjpeg/jpegtclDecls.h \
		zlib/zlibtclDecls.h \
		libpng/pngtclDecls.h \
		libtiff/tifftclDecls.h

	default

	find compat/libtiff/config -name ltmain.sh -delete || die
	sed -i \
		-e 's:"--with-CC=$TIFFCC"::' \
		libtiff/configure.ac || die

	eautoreconf
	for dir in zlib libpng libtiff libjpeg base bmp gif ico jpeg pcx pixmap png\
		ppm ps sgi sun tga tiff window xbm xpm dted raw flir ; do
		(cd ${dir}; AT_NOELIBTOOLIZE=yes eautoreconf)
	done

	eprefixify */*.h
	tc-export AR
}

src_test() {
	virtx default
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
