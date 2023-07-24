# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PLICEASE
DIST_VERSION=2.80
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Build external dependencies for use in CPAN"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="minimal zip"

# No, pkgconfig is not suspect, it actually uses it at runtime, and this module
# is somewhat a wrapper for pkgconfig :/
RDEPEND="
	zip? ( dev-perl/Archive-Zip )
	virtual/perl-Archive-Tar
	>=dev-perl/Capture-Tiny-0.170.0
	virtual/perl-Digest-SHA
	virtual/perl-ExtUtils-CBuilder
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	>=virtual/perl-ExtUtils-ParseXS-3.300.0
	>=dev-perl/FFI-CheckLib-0.110.0
	>=dev-perl/File-Which-1.100.0
	dev-perl/File-chdir
	virtual/perl-JSON-PP
	>=virtual/perl-Scalar-List-Utils-1.330.0
	>=dev-perl/Path-Tiny-0.77.0
	>=virtual/perl-Test-Simple-1.302.96
	>=virtual/perl-Text-ParseWords-3.260.0
	virtual/pkgconfig
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Devel-Hide
		>=dev-perl/Test2-Suite-0.0.121
		!minimal? (
			dev-perl/Alien-Base-ModuleBuild
			dev-perl/Sort-Versions
		)
	)
"
