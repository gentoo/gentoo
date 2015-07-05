# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Multiplex/IO-Multiplex-1.160.0.ebuild,v 1.1 2015/07/05 12:59:19 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BBB
MODULE_VERSION=1.16
inherit perl-module

DESCRIPTION="Manage IO on many file handles "

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
