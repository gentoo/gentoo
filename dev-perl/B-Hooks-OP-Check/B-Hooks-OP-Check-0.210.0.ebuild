# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Wrap OP check callbacks"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND="virtual/perl-parent"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"
