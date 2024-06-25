# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JAWNSY
DIST_VERSION=1.004
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="C implementation of the ISAAC PRNG algorithm"

LICENSE="public-domain || ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~riscv x86"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/Math-Random-ISAAC
	)
"
DEPEND="dev-perl/Module-Build"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	virtual/perl-ExtUtils-ParseXS
	>=dev-perl/Module-Build-0.280.801_rc
	test? (
		>=dev-perl/Test-NoWarnings-0.84.0
		>=virtual/perl-Test-Simple-0.620.0
	)
"

PERL_RM_FILES=(
	# dubious use for gentoo, maybe one day?
	t/03memory.t
	t/05valgrind.t
	# release only
	t/04uniform.t
	t/release-dist-manifest.t
	t/release-kwalitee.t
	t/release-pod-coverage.t
	t/release-pod-syntax.t
	t/release-portability.t
)
