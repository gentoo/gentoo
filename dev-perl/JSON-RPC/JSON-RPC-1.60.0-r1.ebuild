# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DMAKI
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="JSON RPC 2.0 Server Implementation"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE="minimal"

RDEPEND="
	!minimal? ( dev-perl/JSON-XS )
	dev-perl/CGI
	dev-perl/Class-Accessor-Lite
	dev-perl/HTTP-Message
	dev-perl/JSON
	dev-perl/libwww-perl
	dev-perl/Plack
	dev-perl/Router-Simple
	dev-perl/Try-Tiny
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	virtual/perl-CPAN-Meta
	test? (
		>=virtual/perl-ExtUtils-MakeMaker-6.360.0
		virtual/perl-Test-Simple
	)
"
