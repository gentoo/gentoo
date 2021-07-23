# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=2.005004
inherit perl-module

DESCRIPTION="Minimalist Object Orientation (with Moose compatiblity)"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Class-Method-Modifiers-1.100.0
	>=virtual/perl-Exporter-5.570.0
	>=dev-perl/Role-Tiny-2.2.3
	>=virtual/perl-Scalar-List-Utils-1.0.0
	>=dev-perl/Sub-Quote-2.6.6
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.940.0
	)
"
