# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=KNOK
DIST_VERSION=1.30
inherit perl-module

DESCRIPTION="The Perl Image-Info Module"

SLOT="0"
LICENSE="File-MMagic"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
