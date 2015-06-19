# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-NFSLock/File-NFSLock-1.270.0.ebuild,v 1.2 2015/03/22 21:35:01 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BBB
MODULE_VERSION=1.27
inherit perl-module

DESCRIPTION="perl module to do NFS (or not) locking"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
