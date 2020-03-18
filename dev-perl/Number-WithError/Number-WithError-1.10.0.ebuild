# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SMUELLER
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Numbers with error propagation and scientific rounding"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Math-BigInt-1.400.0
	>=dev-perl/Params-Util-0.100.0
	>=dev-perl/prefork-1.0.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		dev-perl/Test-LectroTest
		>=virtual/perl-Test-Simple-0.470.0
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-${DIST_VERSION}-no-dot-inc.patch"
)
PERL_RM_FILES=(
	"t/00podcover.t"
	"t/00pod.t"
)
