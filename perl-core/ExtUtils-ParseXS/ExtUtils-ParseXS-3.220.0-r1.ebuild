# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/ExtUtils-ParseXS/ExtUtils-ParseXS-3.220.0-r1.ebuild,v 1.2 2015/06/05 20:34:06 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=SMUELLER
MODULE_VERSION=3.22
inherit perl-module

DESCRIPTION="Converts Perl XS code into C code"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder"

SRC_TEST="do"
