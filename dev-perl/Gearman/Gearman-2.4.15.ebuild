# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PALIK
DIST_VERSION=2.004.015
inherit perl-module

DESCRIPTION="Gearman distributed job system, client and worker libraries"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-IO
	virtual/perl-IO-Socket-IP
	dev-perl/IO-Socket-SSL
	dev-perl/List-MoreUtils
	virtual/perl-Scalar-List-Utils
	virtual/perl-Socket
	virtual/perl-Storable
	dev-perl/String-CRC32
	virtual/perl-Time-HiRes
	>=virtual/perl-version-0.770.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/File-Which
		virtual/perl-Perl-OSType
		>=dev-perl/Proc-Guard-0.70.0
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
		>=dev-perl/Test-TCP-2.170.0
		dev-perl/Test-Timer
	)
"

mydoc="CHANGES HACKING TODO"
