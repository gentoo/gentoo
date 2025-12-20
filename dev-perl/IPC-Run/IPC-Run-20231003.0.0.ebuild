# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TODDR
DIST_VERSION=20231003.0
inherit perl-module

DESCRIPTION="system() and background procs w/ piping, redirs, ptys"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/IO-Tty-1.80.0
	dev-perl/Readonly
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
