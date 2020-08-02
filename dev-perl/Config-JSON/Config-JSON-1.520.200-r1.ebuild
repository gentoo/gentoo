# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR=RIZEN
DIST_VERSION=1.5202
inherit perl-module

DESCRIPTION="A JSON based config file system"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-File-Temp-0.180.0
	>=dev-perl/JSON-2.160.0
	dev-perl/Moo
	>=virtual/perl-Scalar-List-Utils-1.190.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.700.0
		>=dev-perl/Test-Deep-0.95.0
	)
"
PERL_RM_FILES=(
	t/release-pod-coverage.t
	t/release-pod-syntax.t
)
