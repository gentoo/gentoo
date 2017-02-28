# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=2.213
inherit perl-module

DESCRIPTION="Simple parsing of RFC2822 message format and headers"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Email-Date-Format
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-File-Spec
	)
"
