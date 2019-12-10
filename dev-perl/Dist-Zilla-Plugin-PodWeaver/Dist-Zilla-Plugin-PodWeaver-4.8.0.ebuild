# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=4.008
inherit perl-module

DESCRIPTION="Weave your Pod together from configuration and Dist::Zilla"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Dist-Zilla-5.0.0
	dev-perl/Moose
	dev-perl/PPI
	>=dev-perl/Pod-Elemental-PerlMunger-0.100.0
	dev-perl/Pod-Weaver
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/File-Find-Rule
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
