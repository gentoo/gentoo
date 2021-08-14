# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.010
inherit perl-module

DESCRIPTION='Check for presence of dependencies'

SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc x86"

RDEPEND="
	>=virtual/perl-CPAN-Meta-2.120.920
	>=dev-perl/CPAN-Meta-Check-0.7.0
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
	)
"
