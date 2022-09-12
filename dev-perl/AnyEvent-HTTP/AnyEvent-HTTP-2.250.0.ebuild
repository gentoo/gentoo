# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=2.25
inherit perl-module

DESCRIPTION="Simple but non-blocking HTTP/HTTPS client"

SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-perl/AnyEvent-5.330.0
	dev-perl/URI
	>=dev-perl/common-sense-3.300.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
