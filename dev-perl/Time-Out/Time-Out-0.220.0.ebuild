# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SVW
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Easily timeout long running operations"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Try-Tiny
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/ExtUtils-MakeMaker-CPANfile-0.90.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
	)
"

PERL_RM_FILES=( "t/pod.t" )
