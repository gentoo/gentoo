# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NERDVANA
DIST_VERSION=1.22
inherit perl-module

DESCRIPTION="Generic interface to background process management"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
