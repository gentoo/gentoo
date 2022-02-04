# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=4.009
inherit perl-module

DESCRIPTION="Weave your Pod together from configuration and Dist::Zilla"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-perl/Dist-Zilla-5.0.0
	dev-perl/Moose
	dev-perl/PPI
	>=dev-perl/Pod-Elemental-PerlMunger-0.100.0
	>=dev-perl/Pod-Weaver-4.0.0
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		dev-perl/File-Find-Rule
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
