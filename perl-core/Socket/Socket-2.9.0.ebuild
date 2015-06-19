# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Socket/Socket-2.9.0.ebuild,v 1.5 2015/06/12 22:04:08 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=PEVANS
MODULE_VERSION=2.009
inherit perl-module

DESCRIPTION="Networking constants and support functions"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	virtual/perl-ExtUtils-CBuilder
	>=virtual/perl-ExtUtils-Constant-0.230.0
"

SRC_TEST="do"
