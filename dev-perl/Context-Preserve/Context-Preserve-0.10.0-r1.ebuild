# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Context-Preserve/Context-Preserve-0.10.0-r1.ebuild,v 1.2 2015/06/13 11:32:44 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JROCKWAY
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Pass chained return values from subs, modifying their values, without losing context"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Exception
		|| ( >=virtual/perl-Test-Simple-1.1.10 dev-perl/Test-use-ok )
	)"

SRC_TEST="do"
