# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
