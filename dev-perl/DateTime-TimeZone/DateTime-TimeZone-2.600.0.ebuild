# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Repack/rebuild the bundled tzdata like Fedora does?
# https://src.fedoraproject.org/rpms/perl-DateTime-TimeZone/blob/rawhide/f/perl-DateTime-TimeZone.spec#_148

DIST_AUTHOR=DROLSKY
DIST_VERSION=2.60
inherit perl-module

DESCRIPTION="Time zone object base class and factory"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>=dev-perl/Class-Singleton-1.30.0
	>=virtual/perl-File-Spec-3.0.0
	dev-perl/Module-Runtime
	>=dev-perl/Params-ValidationCompiler-0.130.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
	>=dev-perl/Specio-0.150.0
	dev-perl/Try-Tiny
	dev-perl/namespace-autoclean
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		virtual/perl-File-Temp
		virtual/perl-Storable
		dev-perl/Test-Fatal
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.960.0
	)
"
