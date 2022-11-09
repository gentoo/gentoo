# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="the Utah Raster Toolkit is a library for dealing with raster images"
HOMEPAGE="https://www.cs.utah.edu/gdc/projects/urt/"
SRC_URI="ftp://ftp.iastate.edu/pub/utah-raster/${P}.tar.Z"
S="${WORKDIR}"

LICENSE="URT gif? ( free-noncomm )"
SLOT="0/3.1b-r2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris ~x86-solaris"
IUSE="gif postscript static-libs tiff tools X"

RDEPEND="
	X? ( x11-libs/libXext )
	gif? ( media-libs/giflib )
	postscript? ( app-text/ghostscript-gpl )
	tiff? ( media-libs/tiff:= )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"

PATCHES=(
	"${FILESDIR}"/${P}-rle-fixes.patch
	"${FILESDIR}"/${P}-compile-updates.patch
	"${FILESDIR}"/${P}-tempfile.patch
	"${FILESDIR}"/${P}-r2-build-fixes.patch
	"${FILESDIR}"/${P}-make.patch
	"${FILESDIR}"/${P}-solaris.patch
	"${FILESDIR}"/${P}-librle-toolchain.patch
	"${FILESDIR}"/${P}-implicit-function-declarations.patch
)

urt_config() {
	use $1 && echo "#define $2" || echo "##define $2"
}

src_prepare() {
	rm -f bin/README || die

	default

	# punt bogus manpage #109511
	rm -f man/man1/template.1 || die

	# stupid OS X declares a stack_t type already #107428
	sed -i -e 's:stack_t:_urt_stack:g' tools/clock/rleClock.c || die

}

src_configure() {
	append-cflags -fPIC

	sed -i -e '/^CFLAGS/s: -O : :' makefile.hdr || die

	cp "${FILESDIR}"/gentoo-config config/gentoo || die
	cat >> config/gentoo <<-EOF
	$(urt_config X X11)
	$(urt_config postscript POSTSCRIPT)
	$(urt_config tiff TIFF)
	ExtraCFLAGS = ${CFLAGS}
	MFLAGS = ${MAKEOPTS}
	# prevent circular depend #111455
	$(has_version media-libs/giflib && urt_config gif GIF)
	EOF

	./Configure config/gentoo || die "configure failed"
}

src_compile() {
	tc-export AR RANLIB

	emake CC="$(tc-getCC)" -C lib buildlibso
	emake CC="$(tc-getCC)"
}

src_install() {
	mkdir -p man-dest/man{1,3,5}
	# this just installs it into some local dirs
	emake install

	use tools && dobin bin/*

	use static-libs && dolib.a lib/librle.a

	dolib.so lib/librle.so
	dosym librle.so /usr/$(get_libdir)/librle-0.0.0.so

	insinto /usr/include
	doins include/rle*.h
	doman man-dest/man?/*.[135]
	dodoc *-changes CHANGES* README blurb
}
