# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SIMONW
DIST_VERSION=6.3
inherit perl-module

DESCRIPTION="Automatically give your module the ability to have plugins"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-File-Spec-3
	virtual/perl-if
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		>=virtual/perl-Test-Simple-0.620.0
	)
"
