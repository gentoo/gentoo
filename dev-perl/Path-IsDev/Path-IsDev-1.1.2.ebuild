# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=KENTNL
DIST_VERSION=1.001002
inherit perl-module

DESCRIPTION="Determine if a given Path resembles a development source tree"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-Tiny-0.10.0
	dev-perl/File-HomeDir
	dev-perl/Module-Runtime
	>=dev-perl/Path-Tiny-0.4.0
	dev-perl/Role-Tiny
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	!minimal? ( >=virtual/perl-ExtUtils-MakeMaker-6.980.0 )
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
			>=virtual/perl-Test-Simple-1.1.3
		)
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.890.0
	)
"
