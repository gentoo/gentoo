# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MooseX-FollowPBP/MooseX-FollowPBP-0.50.0.ebuild,v 1.4 2015/01/31 14:20:56 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Name your accessors get_foo() and set_foo(), whatever that may mean"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	dev-perl/Moose
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
