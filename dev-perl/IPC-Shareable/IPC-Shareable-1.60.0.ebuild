# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=STEVEB
DIST_VERSION=1.06
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
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.720.0
	test? (
		>=dev-perl/Test-SharedFork-0.350.0
		virtual/perl-Test-Simple
	)
"

# tests fail when running parallelized, see bug 797445
DIST_TEST=do
