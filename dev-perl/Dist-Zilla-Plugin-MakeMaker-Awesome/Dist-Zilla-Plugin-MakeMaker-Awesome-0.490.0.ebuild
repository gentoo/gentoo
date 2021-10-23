# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.49
inherit perl-module

DESCRIPTION="A more awesome MakeMaker plugin for Dist::Zilla"
SLOT="0"
KEYWORDS="~amd64 ~x86"

XBLOCKS="
	!<=dev-perl/Dist-Zilla-Plugin-MakeMaker-Fallback-0.11.0
"
RDEPEND="${XBLOCKS}
	>=virtual/perl-CPAN-Meta-Requirements-2.121.0
	>=dev-perl/Dist-Zilla-5.1.0
	dev-perl/Moose
	dev-perl/Path-Tiny
	dev-perl/Type-Tiny
	>=virtual/perl-Scalar-List-Utils-1.290.0
	dev-perl/namespace-autoclean
	virtual/perl-version
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
