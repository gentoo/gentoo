# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RSCHUPP
DIST_VERSION=1.017
inherit perl-module

DESCRIPTION="Perl Archive Toolkit"

SLOT="0"
KEYWORDS="amd64 ppc ~riscv x86 ~x86-solaris"

RDEPEND="
	>=dev-perl/Archive-Zip-1.0.0
	>=virtual/perl-AutoLoader-5.660.200
	>=virtual/perl-Digest-SHA-5.450.0
	>=virtual/perl-File-Temp-0.50.0
	>=virtual/perl-IO-Compress-1.300.0
	>=dev-perl/PAR-Dist-0.320.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=( t/00-pod.t )
