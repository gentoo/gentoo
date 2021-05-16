# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KENTNL
DIST_VERSION=1.001003
inherit perl-module

DESCRIPTION="Determine if a given Path resembles a development source tree"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

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
	!minimal? ( >=virtual/perl-ExtUtils-MakeMaker-7.0.0 )
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
			>=virtual/perl-Test-Simple-0.990.0
		)
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
	)
"
