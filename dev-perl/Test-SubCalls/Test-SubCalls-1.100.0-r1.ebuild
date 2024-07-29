# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.10
inherit perl-module

DESCRIPTION="Track the number of times subs are called"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	virtual/perl-Exporter
	>=virtual/perl-File-Spec-0.800.0
	>=dev-perl/Hook-LexWrap-0.200.0
	>=virtual/perl-Test-Simple-0.420.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
