# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic

JUMBOV=20070520
DESCRIPTION="Interactive image manipulation program supporting a wide variety of formats"
HOMEPAGE="http://www.trilon.com/xv/index.html http://www.sonic.net/~roelofs/greg_xv.html"
SRC_URI="mirror://sourceforge/png-mng/${P}-jumbo-patches-${JUMBOV}.tar.gz
	ftp://ftp.cis.upenn.edu/pub/xv/${P}.tar.gz
	mirror://gentoo/${P}.png.bz2"

LICENSE="xv"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="jpeg tiff png"

DEPEND="x11-libs/libXt
	jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0 )
	png? ( >=media-libs/libpng-1.2:0= sys-libs/zlib )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Apply the jumbo patch
	epatch "${WORKDIR}"/${P}-jumbo-fix-enh-patch-${JUMBOV}.txt

	# OSX and BSD xv.h define patches
	epatch "${FILESDIR}"/${P}-osx-bsd-${JUMBOV}.patch

	# OSX malloc patch
	epatch "${FILESDIR}"/${P}-vdcomp-osx-${JUMBOV}.patch

	# Disable JP2K (i.e. use system JPEG libs)
	epatch "${FILESDIR}"/${P}-disable-jp2k-${JUMBOV}.patch

	# Fix -wait option (do not rely on obsolete CLK_TCK)
	epatch "${FILESDIR}"/${P}-fix-wait-${JUMBOV}.patch

	# Use LDFLAGS on link lines
	epatch "${FILESDIR}"/${P}-add-ldflags-${JUMBOV}.patch

	epatch "${FILESDIR}"/${P}-libpng15-r1.patch

	# Link with various image libraries depending on use flags
	IMAGE_LIBS=""
	use jpeg && IMAGE_LIBS="${IMAGE_LIBS} -ljpeg"
	use png && IMAGE_LIBS="${IMAGE_LIBS} -lz -lpng"
	use tiff && IMAGE_LIBS="${IMAGE_LIBS} -ltiff"

	sed -i \
		-e 's/\(^JPEG.*\)/#\1/g' \
		-e 's/\(^PNG.*\)/#\1/g' \
		-e 's/\(^TIFF.*\)/#\1/g' \
		-e "s/\(^LIBS = .*\)/\1${IMAGE_LIBS}/g" Makefile

	# /usr/bin/gzip => /bin/gzip
	sed -i -e 's#/usr\(/bin/gzip\)#'"${EPREFIX}"'\1#g' config.h

	# Fix installation of ps docs
	sed -i -e 's#$(DESTDIR)$(LIBDIR)#$(LIBDIR)#g' Makefile
}

src_compile() {
	append-flags -DUSE_GETCWD -DLINUX -DUSLEEP
	use jpeg && append-flags -DDOJPEG
	use png && append-flags -DDOPNG
	use tiff && append-flags -DDOTIFF -DUSE_TILED_TIFF_BOTLEFT_FIX

	emake \
		CC="$(tc-getCC)" CCOPTS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		PREFIX="${EPREFIX}"/usr \
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}" \
		LIBDIR="${T}"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1

	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}" \
		LIBDIR="${T}" install

	dodoc CHANGELOG BUGS IDEAS
	newicon "${WORKDIR}"/${P}.png ${PN}.png
	make_desktop_entry xv "" "" "Graphics;Viewer"
}
