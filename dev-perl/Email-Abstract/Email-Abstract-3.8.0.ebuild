# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=3.008
inherit perl-module

DESCRIPTION="unified interface to mail representations"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Email-Simple-1.998
	dev-perl/MRO-Compat
	>=dev-perl/Module-Pluggable-1.500.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
