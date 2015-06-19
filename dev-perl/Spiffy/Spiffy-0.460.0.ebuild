# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Spiffy/Spiffy-0.460.0.ebuild,v 1.2 2015/02/28 18:21:41 grobian Exp $

EAPI=5

MODULE_AUTHOR=INGY
MODULE_VERSION=0.46
inherit perl-module

DESCRIPTION="Spiffy Perl Interface Framework For You"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/perl-ExtUtils-MakeMaker-6.300.0"

SRC_TEST="do"
