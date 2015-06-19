# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Perl-OSType/Perl-OSType-1.3.0.ebuild,v 1.3 2015/06/08 20:46:57 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=1.003
inherit perl-module

DESCRIPTION="Map Perl operating system names to generic types"

SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.88
	)"

SRC_TEST="do"
