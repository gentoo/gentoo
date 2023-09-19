# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Show timezone offset strings like +0900"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	virtual/perl-Time-Local
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? ( >=virtual/perl-Test-Simple-0.980.0 )
"
