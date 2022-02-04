# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ALEXMV
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="A virtual browser that retries errors"

SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-perl/libwww-perl"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
