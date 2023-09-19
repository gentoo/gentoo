# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.007
inherit perl-module

DESCRIPTION="Thing with a message method"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/Moose
	dev-perl/MooseX-Role-Parameterized
	dev-perl/String-Errf
	dev-perl/Try-Tiny
	dev-perl/namespace-clean
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
