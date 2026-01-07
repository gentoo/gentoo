# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GAAS
DIST_VERSION=2.10
DIST_SECTION=GAAS
inherit perl-module

DESCRIPTION="String manipulation for Unicode strings"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=virtual/perl-MIME-Base64-2.110.0
"
BDEPEND="${RDEPEND}
"
