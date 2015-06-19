# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Storable/Storable-2.450.0-r1.ebuild,v 1.2 2015/06/12 22:08:57 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=AMS
MODULE_VERSION=2.45
inherit perl-module

DESCRIPTION="The Perl Storable Module"

SLOT="0"
KEYWORDS=""
IUSE=""

#RDEPEND="
#	virtual/perl-XSLoader
#"
#DEPEND="${RDEPEND}"

SRC_TEST="do"
