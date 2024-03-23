# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPS
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="Refresh %INC files when updated on disk"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

BDEPEND="
	dev-perl/Module-Install
	test? ( dev-perl/Path-Class )
"
