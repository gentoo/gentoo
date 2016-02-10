# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=KENTNL
inherit perl-module

DESCRIPTION="Convert arbitrary Perl Modules' versions into normalised Gentoo versions"

SLOT="0"
KEYWORDS="alpha amd64 arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	dev-perl/Sub-Exporter-Progressive
	>=virtual/perl-version-0.770.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Fatal
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.960.0
	)
"
