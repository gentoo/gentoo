# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NWETTERS
DIST_VERSION=2.28
inherit perl-module

DESCRIPTION="Lookup country from IP address or hostname"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="test? ( virtual/perl-Test-Harness )"
