# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MITHALDU
DIST_VERSION=1.112071
inherit perl-module

DESCRIPTION="Test environment setup for development with IDE"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	virtual/perl-File-Temp
"
