# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EVDB
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Simple progess bars"

SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	dev-perl/Term-ProgressBar-Quiet
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
