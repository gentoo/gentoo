# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ILTZU
DIST_VERSION=1.00

inherit perl-module

DESCRIPTION="Use tied scalars as timers"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
BDEPEND="test? ( virtual/perl-Time-HiRes )"
