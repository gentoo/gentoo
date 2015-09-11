# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="the Utah Raster Toolkit is a library for dealing with raster images"
HOMEPAGE="http://www.cs.utah.edu/gdc/projects/urt/"
if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://github.com/sarnold/urt.git"
	inherit git-2
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
fi

LICENSE="URT gif? ( free-noncomm )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="-gif postscript static-libs tiff X"

RDEPEND="X? ( x11-libs/libXext )
	gif? ( media-libs/giflib )
	tiff? ( media-libs/tiff:0 )
	postscript? ( app-text/ghostscript-gpl )"

DEPEND="${RDEPEND}
	X? ( x11-proto/xextproto )"

urt_config() {
	use $1 && echo "#define $2" || echo "##define $2"
}

src_prepare() {
	rm -f bin/README

	epatch "${FILESDIR}"/${P}-shared-lib-build.patch
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

	sed -i \
		-e '/^CFLAGS/s: -O : :' \
		-e 's|CC=gcc|CC ?= gcc|' \
		makefile.hdr

	cp "${FILESDIR}"/gentoo-config config/gentoo
	cat >> config/gentoo <<-EOF
	$(urt_config X X11)
	$(urt_config postscript POSTSCRIPT)
	$(urt_config tiff TIFF)
	ExtraCFLAGS = ${CFLAGS} -fPIC
	MFLAGS = ${MAKEOPTS}
	# prevent circular depend #111455
	$(has_version media-libs/giflib && urt_config gif GIF)
	EOF
}

src_configure() {
	./Configure config/gentoo || die "config failed"
}

src_compile() {
	CC=$(tc-getCC) emake || die "emake failed"
}

src_install() {
	mkdir -p man-dest/man{1,3,5}

	# this just installs it into some local dirs
	make install || die "pre-install failed"

	dobin bin/* || die "dobin failed"
	dolib.so lib/librle.so* || die "dolib.so failed"

	if use static-libs ; then
		dolib.a lib/librle.a
	else
		rm -f "${ED}"usr/$(get_libdir)/librle.a
	fi

	insinto /usr/include
	doins include/rle*.h || die "doins include failed"

	doman man-dest/man?/*.[135]
	dodoc *-changes CHANGES* README blurb
}
