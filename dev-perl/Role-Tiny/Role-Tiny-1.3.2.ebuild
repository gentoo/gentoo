# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Role-Tiny/Role-Tiny-1.3.2.ebuild,v 1.3 2014/12/07 12:56:29 zlogene Exp $

EAPI=5

MODULE_AUTHOR=HAARG
MODULE_VERSION=1.003002
inherit perl-module

DESCRIPTION="Roles. Like a nouvelle cuisine portion size slice of Moose"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~ppc-macos ~x86-solaris"
IUSE="test"

DEPEND="
	test? (
		>=dev-perl/Test-Fatal-0.003
		>=virtual/perl-Test-Simple-0.96
	)
"
RDEPEND="
	!<dev-perl/Moo-0.9.14
"

SRC_TEST="do parallel"
