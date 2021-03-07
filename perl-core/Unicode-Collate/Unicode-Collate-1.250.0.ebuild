# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SADAHIRO
DIST_VERSION=1.25
inherit perl-module

DESCRIPTION="Unicode Collate Algorithm"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
