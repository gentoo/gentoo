# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.991
inherit perl-module

DESCRIPTION="Sophisticated exporter for custom-built routines"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Data-OptList-0.100.0
	>=dev-perl/Params-Util-0.140.0
	>=dev-perl/Sub-Install-0.920.0
"
BDEPEND="${RDEPEND}"
