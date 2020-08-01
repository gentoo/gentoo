# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PLICEASE
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="No line insertion and does Package version with our"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Dist-Zilla-6.0.0
	dev-perl/Moose
	dev-perl/MooseX-Types-Perl
	dev-perl/PPI
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		dev-perl/Path-Tiny
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
		>=dev-perl/Test-Version-0.40.0
	)
"
PERL_RM_FILES=(
	t/author-critic.t
	t/author-eol.t
	t/author-minimum-version.t
	t/author-mojibake.t
	t/author-pod-coverage.t
	t/author-pod-spell.t
	t/author-pod-syntax.t
	t/author-portability.t
	t/author-test-version.t
	t/release-cpan-changes.t
	t/release-dist-manifest.t
	t/release-distmeta.t
	t/release-kwalitee.t
	t/release-meta-json.t
	t/release-unused-vars.t
)
