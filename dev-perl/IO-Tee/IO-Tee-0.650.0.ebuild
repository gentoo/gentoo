# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=0.65
inherit perl-module

DESCRIPTION="Multiplex output to multiple output handles"

SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-IO
	virtual/perl-parent
"
DEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
