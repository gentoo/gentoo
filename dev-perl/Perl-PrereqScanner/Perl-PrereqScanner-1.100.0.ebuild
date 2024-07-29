# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.100

inherit perl-module

DESCRIPTION="Tool to scan your Perl code for its prerequisites"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="minimal"

RDEPEND="
	>=virtual/perl-CPAN-Meta-Requirements-2.124.0
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	dev-perl/Getopt-Long-Descriptive
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Module-Path
	dev-perl/Moo
	>=dev-perl/PPI-1.215.0
	dev-perl/Params-Util
	>=dev-perl/String-RewritePrefix-0.5.0
	dev-perl/Type-Tiny
	dev-perl/namespace-autoclean
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Try-Tiny
	)
"
