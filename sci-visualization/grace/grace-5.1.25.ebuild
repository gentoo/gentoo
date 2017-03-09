# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED=fortran

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="Motif based XY-plotting tool"
HOMEPAGE="http://plasma-gate.weizmann.ac.il/Grace/"
SRC_URI="
	http://pkgs.fedoraproject.org/cgit/grace.git/plain/grace.png
	https://dev.gentoo.org/~jlec/distfiles/${PN}.png.tar
	ftp://plasma-gate.weizmann.ac.il/pub/${PN}/src/stable/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fftw fortran jpeg netcdf png"

DEPEND="
	media-libs/t1lib
	media-libs/tiff:0
	sys-libs/zlib
	>=x11-libs/motif-2.3:0
	x11-libs/xbae
	fftw? ( sci-libs/fftw:2.1= )
	jpeg? ( virtual/jpeg:0 )
	netcdf? ( sci-libs/netcdf )
	png? ( media-libs/libpng:0= )"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils"

PATCHES=(
	# move tmpnam to mkstemp (adapted from debian)
	"${FILESDIR}"/${PN}-5.1.22-mkstemp.patch
	# fix configure instead of aclocal.m4
	"${FILESDIR}"/${PN}-5.1.21-netcdf.patch
	# fix for missing defines when fortran is disabled
	"${FILESDIR}"/${PN}-5.1.21-fortran.patch
	# fix a leak (from freebsd)
	"${FILESDIR}"/${PN}-5.1.22-dlmodule.patch
	"${FILESDIR}"/${PN}-5.1.22-ldflags.patch
)

pkg_setup() {
	fortran-2_pkg_setup
}

src_prepare() {
	default

	# don't strip if not asked for
	sed -i \
		-e 's:$(INSTALL_PROGRAM) -s:$(INSTALL_PROGRAM):g' \
		{auxiliary,grconvert,src}/Makefile || die

	sed -i \
		-e 's:$(GRACE_HOME)/bin:$(PREFIX)/bin:g' \
		-e "s:\$(GRACE_HOME)/lib:\$(PREFIX)/$(get_libdir):g" \
		-e 's:$(GRACE_HOME)/include:$(PREFIX)/include:g' \
		-e 's:$(PREFIX)/man:$(PREFIX)/share/man:g' \
		Makefile */Makefile || die "sed failed"

	sed -i \
		-e 's:bin/grconvert:grconvert:' \
		-e 's:auxiliary/fdf2fit:fdf2fit:' \
		gracerc || die
}

src_configure() {
	tc-export CC AR

	# the configure script just produces a basic Make.conf
	# and a config.h
	econf \
		--disable-pdfdrv \
		--disable-xmhtml \
		--without-bundled-xbae \
		--without-bundled-t1lib \
		--enable-grace-home="${EPREFIX}"/usr/share/${PN} \
		--with-helpviewer="xdg-open %s" \
		--with-editor="xdg-open %s" \
		--with-printcmd="lpr" \
		--x-includes="${EPREFIX}"/usr/include \
		--x-libraries="${EPREFIX}"/usr/$(get_libdir) \
		$(use_with fftw) \
		$(use_enable fortran f77-wrapper) \
		$(use_enable netcdf) \
		$(use_enable jpeg jpegdrv) \
		$(use_enable png pngdrv) \
		$(use_with fortran f77 $(tc-getFC))
}

src_install() {
	default

	dosym ../../${PN}/examples /usr/share/doc/${PF}/examples
	dosym ../../${PN}/doc /usr/share/doc/${PF}/html

	doman "${ED%/}"/usr/share/doc/${PF}/html/*.1
	rm -f "${ED%/}"/usr/share/doc/${PF}/html/*.1 || die

	domenu "${FILESDIR}"/${PN}.desktop
	doicon "${WORKDIR}"/${PN}.png
}
