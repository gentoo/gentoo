# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=2.005005
inherit perl-module

DESCRIPTION="Minimalist Object Orientation (with Moose compatiblity)"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-Method-Modifiers-1.100.0
	>=virtual/perl-Exporter-5.570.0
	>=dev-perl/Role-Tiny-2.2.3
	>=virtual/perl-Scalar-List-Utils-1.0.0
	>=dev-perl/Sub-Quote-2.6.6
	>=dev-perl/Class-XSAccessor-1.190.0-r2
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.940.0
	)
"
