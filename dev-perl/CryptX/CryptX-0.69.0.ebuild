# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR=MIK
DIST_VERSION=0.069
inherit perl-module

DESCRIPTION="Self-contained crypto toolkit"
LICENSE="|| ( Artistic GPL-1+ ) public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		|| (
			dev-perl/Cpanel-JSON-XS
			dev-perl/JSON-XS
			virtual/perl-JSON-PP
		)
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		!minimal? (
			>=virtual/perl-Math-BigInt-1.999.715
			>=virtual/perl-Storable-2.0.0
		)
	)
"
PERL_RM_FILES=(
	t/002_all_pm.t
	t/003_all_pm_pod.t
	t/004_all_pm_pod_spelling.t
	t/005_all_pm_pod_coverage.t
)
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
