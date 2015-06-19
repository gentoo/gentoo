# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-SharedFork/Test-SharedFork-0.210.0-r1.ebuild,v 1.4 2014/11/03 19:57:44 zlogene Exp $

EAPI=5

MODULE_AUTHOR=TOKUHIROM
MODULE_VERSION=0.21
inherit perl-module

DESCRIPTION="fork test"

SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-Test-Harness
	)
"

SRC_TEST=do
