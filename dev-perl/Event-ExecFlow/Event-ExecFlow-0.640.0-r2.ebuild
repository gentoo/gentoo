# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JRED
DIST_VERSION=0.64
inherit perl-module

DESCRIPTION="High level API for event-based execution flow control"

LICENSE="|| ( Artistic GPL-1+ ) LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/AnyEvent-0.400.0
	dev-perl/libintl-perl
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
