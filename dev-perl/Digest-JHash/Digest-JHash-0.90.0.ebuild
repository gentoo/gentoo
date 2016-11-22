# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.09
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl extension for 32 bit Jenkins Hashing Algorithm"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# https://rt.cpan.org/Ticket/Display.html?id=118830
PERL_RM_FILES=(	"Changes~" "dist.ini~" "lib/Digest/JHash.pm~"
				"t/pod.t" "t/cpan-changes.t" "t/pod_coverage.t" )
RDEPEND="
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test
		virtual/perl-Test-Simple
	)
"
