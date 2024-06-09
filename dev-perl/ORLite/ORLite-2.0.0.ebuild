# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=2.00
DIST_TEST="do" # Parallel tests broken
inherit perl-module

DESCRIPTION="Extremely light weight SQLite-specific ORM"

SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=virtual/perl-File-Path-2.08
	>=virtual/perl-File-Temp-0.20
	>=dev-perl/Params-Util-1
	>=dev-perl/DBI-1.607
	>=dev-perl/DBD-SQLite-1.27
	>=dev-perl/File-Remove-1.40
"
BDEPEND="
	${RDEPEND}
	dev-perl/Class-XSAccessor
	test? (
		dev-perl/Test-Deep
		>=dev-perl/Test-Script-1.06
	)
"
