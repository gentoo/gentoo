# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=1.023
inherit perl-module

DESCRIPTION="a tool to scan your Perl code for its prerequisites"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"
# r: File::Find -> perl
# r: File::Spec::Functions -> File-Spec
# r: FindBin  -> perl
# r: List::Util -> Scalar-List-Utils
# r: Moose::Role -> Moose
# r: Scalar::Util -> Scalar-List-Utils
# r: lib, strict, warnings -> perl
RDEPEND="
	>=virtual/perl-CPAN-Meta-Requirements-2.124.0
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	dev-perl/Getopt-Long-Descriptive
	dev-perl/List-MoreUtils
	virtual/perl-Scalar-List-Utils
	dev-perl/Module-Path
	dev-perl/Moose
	>=dev-perl/PPI-1.215.0
	dev-perl/Params-Util
	>=dev-perl/String-RewritePrefix-0.5.0
	dev-perl/namespace-autoclean
"
# t: PPI::Document -> PPI
DEPEND="${RDEPEND}
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
