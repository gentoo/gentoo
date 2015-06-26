# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Guard/Guard-1.23.0.ebuild,v 1.1 2015/06/26 21:44:11 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=1.023
inherit perl-module

DESCRIPTION="Safe cleanup blocks"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
