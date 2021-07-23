# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ADAMK
DIST_VERSION=1.98
inherit perl-module

DESCRIPTION="Extremely light weight SQLite-specific ORM"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=virtual/perl-File-Path-2.08
	>=virtual/perl-File-Temp-0.20
	>=dev-perl/Params-Util-1
	>=dev-perl/DBI-1.607
	>=dev-perl/DBD-SQLite-1.27
	>=dev-perl/File-Remove-1.40
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Script-1.06
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.98-dot-in-inc.patch"
	"${FILESDIR}/${PN}-1.98-vacuum.patch"
)

DIST_TEST="do" # Parallel tests broken
