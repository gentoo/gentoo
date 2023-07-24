# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="Accelerate Cookie::Baker's crush_cookie"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	virtual/perl-Exporter
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
	)
"
