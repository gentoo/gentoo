# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DBOOK
DIST_VERSION=0.004
inherit perl-module

DESCRIPTION="Simple procedural interface to HTTP::Tiny"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-File-Temp
	>=virtual/perl-HTTP-Tiny-0.14.0
	>=virtual/perl-JSON-PP-2.70.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
