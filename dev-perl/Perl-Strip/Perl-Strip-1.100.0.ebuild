# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.1
inherit perl-module

DESCRIPTION="reduce file size by stripping whitespace, comments, pod etc"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/perl-Digest-MD5-2.0.0
	>=dev-perl/PPI-1.213.0
	>=dev-perl/common-sense-3.300.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
