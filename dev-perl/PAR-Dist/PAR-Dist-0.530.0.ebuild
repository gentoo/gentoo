# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RSCHUPP
DIST_VERSION=0.53
inherit perl-module

DESCRIPTION="Create and manipulate PAR distributions"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	|| ( dev-perl/YAML-Syck dev-perl/YAML )
	dev-perl/Archive-Zip
"
BDEPEND="${RDEPEND}"
