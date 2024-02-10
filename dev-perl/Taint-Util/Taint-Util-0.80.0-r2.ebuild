# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AVAR
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Test for and flip the taint flag without regex matches or eval"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	virtual/perl-XSLoader
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
