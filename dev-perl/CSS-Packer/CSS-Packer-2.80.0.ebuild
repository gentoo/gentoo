# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LEEJO
DIST_VERSION=2.08
inherit perl-module

DESCRIPTION="A fast pure Perl CSS minifier"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Regexp-RegGrp-1.1.1_rc
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-File-Contents-0.210.0
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=(
	"t/changes.t"
	"t/pod.t"
)
