# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Role-Tiny/Role-Tiny-2.0.0.ebuild,v 1.3 2015/04/02 10:22:05 zlogene Exp $

EAPI=5

MODULE_AUTHOR=HAARG
MODULE_VERSION=2.000000
inherit perl-module

DESCRIPTION="Roles. Like a nouvelle cuisine portion size slice of Moose"

SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86 ~ppc-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	!<dev-perl/Moo-0.9.14
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST="do parallel"
