# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=1.61
inherit perl-module

DESCRIPTION="Remove files and directories"

LICENSE="|| ( Artistic GPL-1+ ) || ( CC0-1.0 public-domain MIT )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	virtual/perl-File-Path
	>=virtual/perl-File-Spec-3.290.0
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.880.0
	)
"
