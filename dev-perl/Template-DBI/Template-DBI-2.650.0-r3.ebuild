# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=REHSACK
DIST_VERSION=2.65
inherit perl-module

DESCRIPTION="DBI plugin for the Template Toolkit"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 x86 ~x64-macos"

RDEPEND="
	>=dev-perl/DBI-1.612.0
	>=dev-perl/Template-Toolkit-2.220.0
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/MLDBM
		>=dev-perl/SQL-Statement-1.280.0
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.65-no-dot-inc.patch"
)
