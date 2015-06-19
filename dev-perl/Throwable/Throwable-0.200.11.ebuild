# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Throwable/Throwable-0.200.11.ebuild,v 1.1 2014/06/29 11:51:12 zlogene Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.200011
inherit perl-module

DESCRIPTION="A role for classes that can be thrown"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Class-Load-0.200.0
	>=dev-perl/Devel-StackTrace-1.210.0
	>=dev-perl/Moo-1.0.1
	dev-perl/MooX-Types-MooseLike
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.56
"

SRC_TEST=do
