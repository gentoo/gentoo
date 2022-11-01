# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TARAO
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Replace actual time with simulated high resolution time"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-perl/Test-MockTime
	virtual/perl-Test-Simple
	virtual/perl-Time-HiRes
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		dev-perl/Test-Class
		dev-perl/Test-Requires
	)
"
