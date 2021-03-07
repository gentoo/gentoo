# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DANAJ
DIST_VERSION=0.01
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Random numbers using timer/schedule entropy"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Digest-SHA-5.220.0
	>=virtual/perl-Exporter-5.562.0
	>=virtual/perl-Time-HiRes-1.971.100
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.450.0
	)
"
PERL_RM_FILES=(
	t/12-dispersion.t # internally skipped
	t/90-release-perlcritic.t
	t/91-release-pod-syntax.t
	t/92-release-pod-coverage.t
	t/93-release-kwalitee.t
)
