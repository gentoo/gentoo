# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-SharedFork/Test-SharedFork-0.290.0.ebuild,v 1.1 2015/03/22 16:52:20 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=EXODIST
MODULE_VERSION=0.29
inherit perl-module

DESCRIPTION="fork test"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-File-Temp
	>=virtual/perl-Test-Simple-0.880.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-Test-Harness
		virtual/perl-Test-Simple
		dev-perl/Test-Requires
		virtual/perl-Time-HiRes
	)
"

SRC_TEST=do
