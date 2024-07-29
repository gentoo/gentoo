# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ISHIGAKI
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Simple CPAN package extractor"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/perl-Archive-Tar-1.760.0
	dev-perl/Archive-Zip
	virtual/perl-File-Spec
	>=virtual/perl-File-Temp-0.190.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-MakeMaker-CPANfile-0.70.0
	test? (
		>=virtual/perl-Test-Simple-0.820.0
		>=dev-perl/Test-UseAllModules-0.100.0
	)
"
