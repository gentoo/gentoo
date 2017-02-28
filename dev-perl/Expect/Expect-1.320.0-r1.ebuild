# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SZABGAB
MODULE_VERSION=1.32
inherit perl-module

DESCRIPTION="Expect for Perl"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 sparc x86"
IUSE="test minimal"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-IO
	>=dev-perl/IO-Tty-1.110.0
	!minimal? (
		dev-perl/IO-Stty
	)
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-File-Temp
		>=dev-perl/Test-Exception-0.320.0
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"
