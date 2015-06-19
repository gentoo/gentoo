# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Throwable/Throwable-0.102.80.ebuild,v 1.4 2014/07/31 17:46:40 zlogene Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.102080
inherit perl-module

DESCRIPTION="a role for classes that can be thrown"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-perl/Devel-StackTrace-1.21
	>=dev-perl/Moose-0.87"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.56"

SRC_TEST=do
