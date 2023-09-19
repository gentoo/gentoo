# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=0.48
inherit perl-module

DESCRIPTION="A more awesome MakeMaker plugin for Dist::Zilla"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

XBLOCKS="
	!<=dev-perl/Dist-Zilla-Plugin-MakeMaker-Fallback-0.11.0
"
RDEPEND="${XBLOCKS}
	>=virtual/perl-CPAN-Meta-Requirements-2.121.0
	>=dev-perl/Dist-Zilla-5.1.0
	dev-perl/Moose
	dev-perl/MooseX-Types-Stringlike
	dev-perl/Path-Tiny
	>=virtual/perl-Scalar-List-Utils-1.290.0
	dev-perl/namespace-autoclean
	virtual/perl-version
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
		virtual/perl-File-Spec
		dev-perl/File-pushd
		virtual/perl-Module-Metadata
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-if
	)
"
