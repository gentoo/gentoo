# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NWELLNHOF
DIST_VERSION=3.03
inherit perl-module

DESCRIPTION="Build an IP address to country code database"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="dev-perl/IP-Country"
DEPEND="test? (
		${RDEPEND}
		dev-perl/Math-Int64
		virtual/perl-DB_File
		virtual/perl-Test-Harness
	)
"
