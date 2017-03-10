# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KENTNL
DIST_VERSION=1.000008
inherit perl-module

DESCRIPTION="Simple set-and-forget using of a '/share' directory in your projects root"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test minimal"

RDEPEND="
	!minimal? ( >=dev-perl/Path-Tiny-0.58.0 )
	virtual/perl-Carp
	dev-perl/File-ShareDir
	dev-perl/Path-FindDev
	dev-perl/Path-IsDev
	dev-perl/Path-Tiny
	dev-perl/Sub-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	!minimal? ( >=virtual/perl-ExtUtils-MakeMaker-7.0.0 )
	test? (
		!minimal? (
			>=dev-perl/Capture-Tiny-0.120.0
			>=virtual/perl-CPAN-Meta-2.120.900
			>=virtual/perl-Test-Simple-0.990.0
		)
		dev-perl/Class-Tiny
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
