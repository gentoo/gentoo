# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="SHLOMIF"
DIST_VERSION="0.0601"
inherit perl-module

DESCRIPTION="Test for trailing space in source files"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=dev-perl/File-Find-Object-Rule-0.30.100
	virtual/perl-autodie
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Path
		virtual/perl-File-Spec
		dev-perl/File-TreeCreate
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
