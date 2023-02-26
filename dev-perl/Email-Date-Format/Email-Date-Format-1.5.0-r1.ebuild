# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.005
inherit perl-module

DESCRIPTION="Produce RFC 822 date strings"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-Time-Local
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
