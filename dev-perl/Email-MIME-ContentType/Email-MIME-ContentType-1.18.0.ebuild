# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.018
inherit perl-module

DESCRIPTION="Parse a MIME Content-Type Header"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~x86 ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
