# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=0.048
inherit perl-module

DESCRIPTION="Run external commands and code at specific phases of Dist::Zilla"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	dev-perl/Dist-Zilla
	virtual/perl-File-Spec
	dev-perl/Moose
	dev-perl/Path-Tiny
	>=dev-perl/String-Formatter-0.102.82
	dev-perl/namespace-autoclean
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		dev-perl/File-pushd
		virtual/perl-Module-Metadata
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-File-ShareDir
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-if
	)
"
