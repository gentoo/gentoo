# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SVW
inherit perl-module

DESCRIPTION="Easily timeout long running operations"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Try-Tiny
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/ExtUtils-MakeMaker-CPANfile-0.90.0
	>=virtual/perl-ExtUtils-MakeMaker-6.760.0
	test? (
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Harness-3.500.0
		dev-perl/Test-Needs
	)
"

PERL_RM_FILES=( "t/pod.t" )
