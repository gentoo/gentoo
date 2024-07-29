# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.40
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Localization support for DateTime"

LICENSE="|| ( Artistic GPL-1+ ) unicode"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Dist-CheckConflicts-0.20.0
	virtual/perl-Exporter
	dev-perl/File-ShareDir
	virtual/perl-File-Spec
	>=dev-perl/Params-ValidationCompiler-0.130.0
	>=virtual/perl-Scalar-List-Utils-1.450.0
	>=dev-perl/Specio-0.150.0
	virtual/perl-Storable
	>=dev-perl/namespace-autoclean-0.190.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		virtual/perl-CPAN-Meta-Requirements
		>=dev-perl/CPAN-Meta-Check-0.11.0
		virtual/perl-File-Temp
		dev-perl/IPC-System-Simple
		dev-perl/Path-Tiny
		dev-perl/Test-File-ShareDir
		>=virtual/perl-Test-Simple-1.302.15
		dev-perl/Test2-Plugin-NoWarnings
		virtual/perl-Test2-Suite
	)
"
