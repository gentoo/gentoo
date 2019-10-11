# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="the Utah Raster Toolkit is a library for dealing with raster images"
HOMEPAGE="http://www.cs.utah.edu/gdc/projects/urt/"
SRC_URI="ftp://ftp.iastate.edu/pub/utah-raster/${P}.tar.Z"

LICENSE="URT gif? ( free-noncomm )"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="gif postscript tiff X"

RDEPEND="X? ( x11-libs/libXext )
	gif? ( media-libs/giflib )
	tiff? ( media-libs/tiff )
	postscript? ( app-text/ghostscript-gpl )"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

S=${WORKDIR}

urt_config() {
	use $1 && echo "#define $2" || echo "##define $2"
}

src_prepare() {
	rm -f bin/README

	epatch "${FILESDIR}"/${P}-rle-fixes.patch
	epatch "${FILESDIR}"/${P}-compile-updates.patch
	epatch "${FILESDIR}"/${P}-tempfile.patch
	epatch "${FILESDIR}"/${P}-build-fixes.patch
	epatch "${FILESDIR}"/${P}-make.patch
	epatch "${FILESDIR}"/${P}-solaris.patch

	# punt bogus manpage #109511
	rm -f man/man1/template.1

	# stupid OS X declares a stack_t type already #107428
	sed -i -e 's:stack_t:_urt_stack:g' tools/clock/rleClock.c || die

	sed -i -e '/^CFLAGS/s: -O : :' makefile.hdr
	cp "${FILESDIR}"/gentoo-config config/gentoo
	cat >> config/gentoo <<-EOF
	$(urt_config X X11)
	$(urt_config postscript POSTSCRIPT)
	$(urt_config tiff TIFF)
	ExtraCFLAGS = ${CFLAGS}
	MFLAGS = ${MAKEOPTS}
	# prevent circular depend #111455
	$(has_version media-libs/giflib && urt_config gif GIF)
	EOF
}

src_configure() {
	./Configure config/gentoo || die "config"
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	mkdir -p man-dest/man{1,3,5}
	# this just installs it into some local dirs
	make install || die
	dobin bin/*
	dolib.a lib/librle.a
	insinto /usr/include
	doins include/rle*.h
	doman man-dest/man?/*.[135]
	dodoc *-changes CHANGES* README blurb
}
