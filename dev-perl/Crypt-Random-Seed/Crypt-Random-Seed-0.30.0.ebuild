# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DANAJ
DIST_VERSION=0.03
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Simple method to get strong randomness"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Crypt-Random-TESHA2
	>=virtual/perl-Exporter-5.562.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.450.0
	)
"
PERL_RM_FILES=(
	t/90-release-perlcritic.t
	t/91-release-pod-syntax.t
	t/92-release-pod-coverage.t
	t/93-release-kwalitee.t
	t/94-release-manifest.t
)
