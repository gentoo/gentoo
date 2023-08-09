# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=STEVEB
DIST_VERSION=1.13
# Tests fail when running parallelized, see bug #797445
#DIST_TEST=do
inherit perl-module

DESCRIPTION="Share Perl variables between processes"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/JSON
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Storable-0.607.0
	dev-perl/String-CRC32
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.720.0
	test? (
		>=dev-perl/Test-SharedFork-0.350.0
		virtual/perl-Test-Simple
		dev-perl/Mock-Sub
	)
"
