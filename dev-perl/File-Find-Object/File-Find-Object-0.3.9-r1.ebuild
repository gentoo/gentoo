# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
inherit perl-module

DESCRIPTION="An object oriented File::Find replacement"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-perl/Class-XSAccessor
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		dev-perl/File-TreeCreate
		>=dev-perl/Test-File-1.993.0
	)
"
