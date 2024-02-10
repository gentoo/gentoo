# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ISHIGAKI
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="cpanfile support for EUMM"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	dev-perl/Module-CPANfile
	>=virtual/perl-version-0.760.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
