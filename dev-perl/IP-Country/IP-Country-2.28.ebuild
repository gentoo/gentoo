# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NWETTERS

inherit perl-module

DESCRIPTION="Lookup country from IP address or hostname"

SLOT="0"
LICENSE="|| ( Artistic GPL-1+ )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="test? ( virtual/perl-Test-Harness )"
