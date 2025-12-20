# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ABIGAIL
DIST_VERSION=2024080801
inherit perl-module

DESCRIPTION="Provide commonly requested regular expressions"

LICENSE="|| ( Artistic Artistic-2 MIT BSD )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	test? ( dev-perl/Test-Regexp )
"
