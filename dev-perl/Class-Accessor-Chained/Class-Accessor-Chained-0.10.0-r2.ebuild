# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RCLAMP
DIST_VERSION=0.01
inherit perl-module

DESCRIPTION="Perl module to make chained class accessors"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Class-Accessor"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"
