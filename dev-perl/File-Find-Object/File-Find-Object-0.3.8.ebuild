# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
inherit perl-module

DESCRIPTION="An object oriented File::Find replacement"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-XSAccessor
	virtual/perl-File-Spec
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Path
		dev-perl/File-TreeCreate
		>=dev-perl/Test-File-1.993.0
	)
"
