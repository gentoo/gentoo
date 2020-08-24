# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ADAMK
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Pure-OO reimplementation of dumpvar.pl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.180.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		>=virtual/perl-File-Spec-0.800.0
		>=virtual/perl-Test-Simple-0.420.0
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.06-no-dot-inc.patch"
)
PERL_RM_FILES=(
	t/97_meta.t
	t/98_pod.t
	t/99_pmv.t
)
