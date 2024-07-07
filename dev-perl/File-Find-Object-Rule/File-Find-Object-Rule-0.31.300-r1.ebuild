# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="SHLOMIF"
DIST_VERSION="0.0313"
inherit perl-module

DESCRIPTION="Alternative interface to File::Find::Object"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc64 ~riscv ~sparc x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-XSAccessor
	dev-perl/File-Find-Object
	dev-perl/Number-Compare
	dev-perl/Text-Glob
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Path
		dev-perl/File-TreeCreate
		virtual/perl-IO
	)
"
