# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic toolchain-funcs

COMMIT_ID=e5a6997b9d494f3010b2c32b1e3f0660ec7991ac
DESCRIPTION="the Utah Raster Toolkit is a library for dealing with raster images"
HOMEPAGE="https://sarnold.github.io/urt/ https://github.com/sarnold/urt"
SRC_URI="https://github.com/sarnold/urt/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_ID}"

LICENSE="GPL-2 gif? ( free-noncomm )"
SLOT="0/3.1.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-solaris"
IUSE="gif postscript static-libs tiff tools X"

RDEPEND="
	gif? ( media-libs/giflib )
	postscript? ( app-text/ghostscript-gpl )
	tiff? ( media-libs/tiff:= )
	X? ( x11-libs/libXext )
"

DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"

PATCHES=(
	"${FILESDIR}"/${P}-respect-ldflags.patch
	"${FILESDIR}"/${P}-ar.patch
)

urt_config() {
	use $1 && echo "#define $2" || echo "##define $2"
}

src_prepare() {
	rm bin/README || die

	default
}

src_configure() {
	append-cflags -fPIC

	sed -i -e '/^CFLAGS/s: -O2 : :' makefile.hdr || die

	cat >> config/gentoo <<-EOF
	$(urt_config X X11)
	$(urt_config gif GIF)
	$(urt_config postscript POSTSCRIPT)
	$(urt_config tiff TIFF)
	ExtraCFLAGS = ${CFLAGS}
	MFLAGS = ${MAKEOPTS}
	EOF

	edob -m "Configuring" ./Configure config/gentoo
}

src_compile() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
}

src_install() {
	mkdir -p man-dest/man{1,3,5}
	# this just installs it into some local dirs
	emake install

	use tools && dobin bin/*

	use static-libs && dolib.a lib/librle.a

	dolib.so lib/librle.so
	dolib.so lib/librle.so.3
	dolib.so lib/librle.so.3.1.0
	dosym librle.so /usr/$(get_libdir)/librle-0.0.0.so

	insinto /usr/include
	doins include/rle*.h
	doman man-dest/man?/*.[135]
	dodoc *-changes CHANGES* README* blurb
}
