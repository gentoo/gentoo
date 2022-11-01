# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.44
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="GNU C library compatible strftime for loggers and servers"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="minimal"

RDEPEND="
	!minimal? ( dev-perl/Time-TZOffset )
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Time-Local
"

BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	virtual/perl-CPAN-Meta
	test? ( >=virtual/perl-Test-Simple-0.980.0 )
"
