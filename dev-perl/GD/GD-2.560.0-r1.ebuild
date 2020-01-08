# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LDS
DIST_VERSION=2.56
inherit perl-module

DESCRIPTION="Interface to Thomas Boutell's gd library"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="animgif gif jpeg png truetype xpm"
PATCHES=(
	"${FILESDIR}/${P}-rt106594.patch"
)
RDEPEND="
	virtual/perl-Math-Complex
	>=media-libs/gd-2.0.33
	png? (
		media-libs/gd[png]
		media-libs/libpng:0
		sys-libs/zlib
	)
	jpeg? (
		media-libs/gd[jpeg]
		virtual/jpeg:0
	)
	truetype? (
		media-libs/gd[truetype]
		media-libs/freetype:2
	)
	xpm? (
		media-libs/gd[xpm]
		x11-libs/libXpm
	)
	gif? ( media-libs/giflib )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-MakeMaker
"

PREFER_BUILDPL="no"

src_prepare(){
	perl-module_src_prepare

	# bug 572000
	ln -s "${S}"/lib/GD.xs "${S}"/GD.xs

	sed -i "s/use Getopt::Long;/use Getopt::Long qw(:config pass_through);/" \
		"${S}"/Makefile.PL || die
}

src_configure() {
	local myconf
	use gif && use animgif && myconf+=",ANIMGIF"
	use jpeg && myconf+=",JPEG"
	use truetype && myconf+=",FT"
	use png && myconf+=",PNG"
	use xpm && myconf+=",XPM"
	use gif && myconf+=",GIF"
	myconf="-options '${myconf:1}'"
	perl-module_src_configure
}

mydoc="GD.html"
