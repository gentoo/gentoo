# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DOHERTY
DIST_VERSION=2.000007
inherit perl-module

DESCRIPTION="Release tests for minimum required versions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Dist-Zilla-4.0.0
	dev-perl/Moose
	dev-perl/Test-MinimumVersion
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Output
		>=virtual/perl-Test-Simple-0.960.0
	)
"
