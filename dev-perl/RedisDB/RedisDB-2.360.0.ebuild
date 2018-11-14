# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ZWON
MODULE_VERSION=2.36
inherit perl-module

DESCRIPTION="Perl extension to access redis database"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

SRC_TEST="do"

RDEPEND="
	virtual/perl-Encode
	virtual/perl-IO-Socket-IP
	dev-perl/RedisDB-Parser
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-Digest-SHA
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Differences
		dev-perl/Test-FailWarnings
		virtual/perl-Test-Simple
		dev-perl/Test-Most
		dev-perl/Test-TCP
	)
"
