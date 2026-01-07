# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Thoroughly testing objects via registered handlers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=virtual/perl-Scalar-List-Utils-1.160.0
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-File-Spec )
"
