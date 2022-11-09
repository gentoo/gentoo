# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RURBAN
DIST_VERSION=2.73
DIST_EXAMPLES=("demos/*")
inherit perl-module

DESCRIPTION="Interface to Thomas Boutell's gd library"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="animgif fcgi test truetype xpm"

RDEPEND="
	>=media-libs/gd-2.2.3[png,jpeg]
	media-libs/giflib
	media-libs/libpng:0
	sys-libs/zlib
	virtual/jpeg:0
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
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-Constant-0.230.0
	dev-perl/ExtUtils-PkgConfig
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Fork-0.20.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"

RESTRICT="!test? ( test )"

src_prepare() {
	perl-module_src_prepare
	sed -i "s/use Getopt::Long;/use Getopt::Long qw(:config pass_through);/" \
		"${S}"/Makefile.PL || die
}

src_configure() {
	local myconf
	myconf="VERSION_33,GD_UNCLOSEDPOLY,GD_FTCIRCLE" # Per line 284 of Makefile.PL

	# The following flags do not work properly. This is why we force-enable
	# at least some of them. See bug 787404 as tracker.
	use animgif && myconf+=",ANIMGIF"
	myconf+=",JPEG"
	use truetype && myconf+=",FT"
	myconf+=",PNG"
	use xpm && myconf+=",XPM"
	myconf+=",GIF"
	myconf="-options '${myconf}'"
	use fcgi && myconf+=" --fcgi"
	perl-module_src_configure
}

src_test() {
	perl_rm_files t/z_*.t
	perl-module_src_test
}
