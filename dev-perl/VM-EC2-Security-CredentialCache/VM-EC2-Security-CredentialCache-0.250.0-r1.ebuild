# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RCONOVER
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="Cache credentials respecting expiration time for IAM roles"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-perl/DateTime-Format-ISO8601
	dev-perl/VM-EC2
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
