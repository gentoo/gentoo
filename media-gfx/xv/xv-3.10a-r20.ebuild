# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

JUMBOV=20070520
DESCRIPTION="Interactive image manipulation program supporting a wide variety of formats"
HOMEPAGE="http://www.trilon.com/xv/index.html http://www.sonic.net/~roelofs/greg_xv.html"
SRC_URI="mirror://sourceforge/png-mng/${P}-jumbo-patches-${JUMBOV}.tar.gz
	ftp://ftp.cis.upenn.edu/pub/xv/${P}.tar.gz
	mirror://gentoo/${P}.png.bz2"

LICENSE="xv"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="jpeg tiff png"

DEPEND="
	x11-libs/libXt
	jpeg? ( media-libs/libjpeg-turbo:= )
	tiff? ( media-libs/tiff )
	png? (
		>=media-libs/libpng-1.2:=
		sys-libs/zlib
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${WORKDIR}/${P}-jumbo-fix-enh-patch-${JUMBOV}.txt"
	"${FILESDIR}/${P}-osx-bsd-${JUMBOV}.patch"
	"${FILESDIR}/${P}-vdcomp-osx-${JUMBOV}.patch"
	"${FILESDIR}/${P}-disable-jp2k-${JUMBOV}.patch"
	"${FILESDIR}/${P}-fix-wait-${JUMBOV}.patch"
	"${FILESDIR}/${P}-add-ldflags-${JUMBOV}.patch"
	"${FILESDIR}/${P}-libpng15-r1.patch"
	"${FILESDIR}/${P}-wformat-security.patch"
)

src_prepare() {
	default

	append-cppflags -DUSE_GETCWD -DLINUX -DUSLEEP
	use jpeg && append-cppflags -DDOJPEG
	use png && append-cppflags -DDOPNG
	use tiff && append-cppflags -DDOTIFF -DUSE_TILED_TIFF_BOTLEFT_FIX

	# Link with various image libraries depending on use flags
	IMAGE_LIBS=""
	use jpeg && IMAGE_LIBS="${IMAGE_LIBS} -ljpeg"
	use png && IMAGE_LIBS="${IMAGE_LIBS} -lz -lpng"
	use tiff && IMAGE_LIBS="${IMAGE_LIBS} -ltiff"

	sed -i \
		-e 's/\(^JPEG.*\)/#\1/g' \
		-e 's/\(^PNG.*\)/#\1/g' \
		-e 's/\(^TIFF.*\)/#\1/g' \
		-e "s/\(^LIBS = .*\)/\1${IMAGE_LIBS}/g" Makefile || die

	# 731022
	sed -i -e "s#lib -lz#$(get_libdir) -lz#" Makefile || die

	# /usr/bin/gzip => /bin/gzip
	sed -i -e 's#/usr\(/bin/gzip\)#'"${EPREFIX}"'\1#g' config.h || die

	# Fix installation of ps docs
	sed -i -e 's#$(DESTDIR)$(LIBDIR)#$(LIBDIR)#g' Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" CCOPTS="${CPPFLAGS} ${CFLAGS}" LDFLAGS="${LDFLAGS}" \
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
