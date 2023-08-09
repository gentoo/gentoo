# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.010
inherit perl-module

DESCRIPTION="List modules and versions loaded if tests fail"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
	virtual/perl-File-Spec
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=dev-perl/Capture-Tiny-0.210.0
	)
"
