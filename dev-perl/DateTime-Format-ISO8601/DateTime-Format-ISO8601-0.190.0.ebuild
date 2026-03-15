# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="Parses ISO8601 formats"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-perl/DateTime-1.450.0
	>=dev-perl/DateTime-Format-Builder-0.770.0
	>=dev-perl/Params-ValidationCompiler-0.260.0
	>=dev-perl/Specio-0.180.0
	dev-perl/namespace-autoclean
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		>=virtual/perl-Test-Simple-1.302.15
	)
"
