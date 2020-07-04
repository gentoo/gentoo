# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SMUELLER
DIST_VERSION=1.02
inherit perl-module

DESCRIPTION="Container for the AutoXS header files"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-aix ~ppc-macos ~x86-solaris"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
