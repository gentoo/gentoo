# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Time-Stopwatch/Time-Stopwatch-1.0.0.ebuild,v 1.1 2013/09/12 14:21:34 dev-zero Exp $

EAPI=5

MODULE_AUTHOR="ILTZU"
MODULE_VERSION="1.00"

inherit perl-module

DESCRIPTION="Use tied scalars as timers"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=""
DEPEND="test? ( virtual/perl-Time-HiRes )"

SRC_TEST="do"
