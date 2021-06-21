# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.66
inherit perl-module

DESCRIPTION="Multiplex output to multiple output handles"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-IO
	virtual/perl-parent
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
