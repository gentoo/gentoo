# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MooX-Types-MooseLike-Numeric/MooX-Types-MooseLike-Numeric-1.20.0.ebuild,v 1.1 2014/11/30 21:59:54 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MATEU
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION="Moo types for numbers"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/MooX-Types-MooseLike-0.230.0
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.96
	)
"

SRC_TEST="do parallel"
