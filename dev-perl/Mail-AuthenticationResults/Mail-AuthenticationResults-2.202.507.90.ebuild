# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MBRADSHAW
DIST_VERSION=2.20250709
inherit perl-module

DESCRIPTION="Object Oriented Authentication-Results Headers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-perl/Clone
	dev-perl/JSON
"
BDEPEND="
	${RDEPEND}
	test? ( dev-perl/Test-Exception )
"
