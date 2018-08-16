# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.42
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="GNU C library compatible strftime for loggers and servers"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="test minimal"

# POSIX -> perl
RDEPEND="
	!minimal? ( dev-perl/Time-TZOffset )
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Time-Local
"

# CPAN::Meta::Prereqs -> perl-CPAN-Meta
DEPEND="
	>=dev-perl/Module-Build-0.380.0
	virtual/perl-CPAN-Meta
	${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.980.0 )
"
