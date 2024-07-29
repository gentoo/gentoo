# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DOUGW
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="Perl module for reading TNEF files"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 sparc x86"

RDEPEND="
	>=dev-perl/MIME-tools-4.109.0
	dev-perl/IO-stringy
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
