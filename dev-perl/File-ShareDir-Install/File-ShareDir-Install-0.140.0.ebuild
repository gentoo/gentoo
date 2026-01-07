# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.14

inherit perl-module

DESCRIPTION="Install shared files"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-File-Spec
	virtual/perl-IO
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		virtual/perl-Test-Simple
	)
"
