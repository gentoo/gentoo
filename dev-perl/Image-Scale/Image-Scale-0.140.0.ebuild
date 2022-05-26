# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AGRUNDMA
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Fast, high-quality fixed-point image resizing"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gif jpeg +png test"
RESTRICT="!test? ( test )"

REQUIRED_USE="|| ( jpeg png )"

RDEPEND="
	png? (
		media-libs/libpng:0
	)
	jpeg? (
		virtual/jpeg:0
	)
	gif? (
		media-libs/giflib
	)
"
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-NoWarnings
	)
	virtual/perl-ExtUtils-MakeMaker
"

# https://rt.cpan.org/Ticket/Display.html?id=112217
DIST_TEST="do"

PATCHES=(
	"${FILESDIR}"/0.80.0-disable_autodetect.patch
)

PERL_RM_FILES=( "t/04critic.t" "t/02pod.t" "t/03podcoverage.t" )

src_configure() {
	local myconf
	for useflag in png jpeg gif; do
		myconf+=( $(usex $useflag "" --disable-${useflag}) )
	done
	perl-module_src_configure
}
