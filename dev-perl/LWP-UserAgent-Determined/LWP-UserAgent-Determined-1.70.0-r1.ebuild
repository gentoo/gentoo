# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ALEXMV
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="A virtual browser that retries errors"

SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~sparc x86"

RDEPEND="dev-perl/libwww-perl"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
