# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.1
inherit perl-module

DESCRIPTION="truly asynchronous file and directory I/O"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/AnyEvent-3.400.0
	>=dev-perl/IO-AIO-3.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
