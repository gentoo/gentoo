# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=KENTNL
DIST_VERSION=2.002003
inherit perl-module

DESCRIPTION="Generating and Populating 'provides' in your META.yml"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Dist-Zilla
	dev-perl/Hash-Merge-Simple
	dev-perl/Moose
	dev-perl/MooseX-Types
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-7.0.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=dev-perl/Path-Tiny-0.58.0
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.990.0
	)
"
