# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.22
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Build an optimized subroutine parameter validator once, use it forever"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Eval-Closure
	dev-perl/Exception-Class
	virtual/perl-Exporter
	>=virtual/perl-Scalar-List-Utils-1.400.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=dev-perl/Specio-0.140.0
		>=virtual/perl-Test-Simple-1.302.15
		dev-perl/Test-Without-Module
		dev-perl/Test2-Suite
		dev-perl/Test2-Plugin-NoWarnings
	)
"
