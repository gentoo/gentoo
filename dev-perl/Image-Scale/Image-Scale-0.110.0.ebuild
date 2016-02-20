# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=AGRUNDMA
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Fast, high-quality fixed-point image resizing"

LICENSE="|| ( GPL-2 GPL-3 )" # GPL2+
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gif jpeg +png test"

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
	test? (
		dev-perl/Test-NoWarnings
	)
	virtual/perl-ExtUtils-MakeMaker
"
RESTRICT="test" # https://rt.cpan.org/Ticket/Display.html?id=112217
PATCHES=(
	"${FILESDIR}"/0.80.0-disable_autodetect.patch
)
src_prepare() {
	use test && perl_rm_files "t/04critic.t" "t/02pod.t" "t/03podcoverage.t"
	perl-module_src_prepare
}
src_configure() {
	local myconf
	for useflag in png jpeg gif; do
		myconf+=( $(usex $useflag "" --disable-${useflag}) )
	done
	perl-module_src_configure
}
