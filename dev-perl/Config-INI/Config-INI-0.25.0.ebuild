# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=0.025
inherit perl-module

DESCRIPTION="simple .ini-file format"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"

# r: Mixin::Linewise::Readers -> Mixin-Linewise
# r: Mixin::Linewise::Writers -> Mixin-Linewise
# r: strict, warnings -> perl
RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Mixin-Linewise-0.105.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.960.0
	)
"
