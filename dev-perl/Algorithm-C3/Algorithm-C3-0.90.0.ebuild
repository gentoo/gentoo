# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Algorithm-C3/Algorithm-C3-0.90.0.ebuild,v 1.6 2015/06/21 08:37:01 zlogene Exp $

EAPI=5

MODULE_AUTHOR=HAARG
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="A module for merging hierarchies using the C3 algorithm"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST=do
