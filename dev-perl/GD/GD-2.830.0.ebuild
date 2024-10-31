# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RURBAN
DIST_VERSION=2.83
DIST_EXAMPLES=("demos/*")
inherit perl-module

DESCRIPTION="Interface to Thomas Boutell's gd library"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
IUSE="animgif fcgi test truetype xpm"

RDEPEND="
	>=media-libs/gd-2.2.3[png,jpeg]
	media-libs/giflib
	media-libs/libjpeg-turbo
	media-libs/libpng
	sys-libs/zlib
	truetype? (
		media-libs/gd[truetype]
		media-libs/freetype:2
	)
	xpm? (
		media-libs/gd[xpm]
		x11-libs/libXpm
	)
	fcgi? (
		dev-libs/fcgi
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-Constant-0.230.0
	dev-perl/ExtUtils-PkgConfig
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/File-Which
	test? (
		>=dev-perl/Test-Fork-0.20.0
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-NoWarnings-1.0.0
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.820.0-respect-libdir.patch
)

src_configure() {
	local myconfargs=(
		VERSION_33
		GD_UNCLOSEDPOLY
		GD_FTCIRCLE

		WINDOWS_BMP
		JPEG
		PNG
		GIF
	)

	# The following flags do not work properly. This is why we force-enable
	# at least some of them. See bug 787404 as tracker.
	use animgif && myconfargs+=( ANIMGIF )
	use truetype && myconfargs+=( FT )
	use xpm && myconfargs+=( XPM )

	# Per line 284 of Makefile.PL
	local myconf="--lib_gd_path ${ESYSROOT}/usr/$(get_libdir) -options '$(printf '%s,' ${myconfargs[@]})'"
	use fcgi && myconf+=" --fcgi"

	perl-module_src_configure
}

src_test() {
	# The 'GD' format itself is long-obsolete and gone in >=media-libs/gd-2.3.3
	perl_rm_files t/z_*.t t/GD.t
	perl-module_src_test
}
