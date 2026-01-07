# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RCLAMP
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Match globbing patterns against text"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
