# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KAZUHO
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="A simple, high-performance PSGI/Plack HTTP server"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Parallel-Prefork-0.170.0
	>=dev-perl/Plack-0.992.0
	>=dev-perl/Server-Starter-0.60.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=dev-perl/Test-TCP-2.100.0
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/libwww-perl
		>=virtual/perl-Test-Simple-0.880.0
	)
"
