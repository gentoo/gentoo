# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=0.200002
inherit perl-module

DESCRIPTION="write-once, read-many attributes for Moose"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# r: Moose::Role -> Moose
# r: strict, warnings -> perl
RDEPEND="
	>=dev-perl/Moose-0.900.0
"
# t: IO::Handle -> IO
# t: IPC::Open3 -> perl
# t: Test::More -> Test-Simple
# t: lib -> perl
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
