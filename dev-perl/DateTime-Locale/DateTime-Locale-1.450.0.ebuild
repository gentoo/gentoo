# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.45
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Localization support for DateTime"

LICENSE="|| ( Artistic GPL-1+ ) unicode"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>=dev-perl/Dist-CheckConflicts-0.20.0
	dev-perl/File-ShareDir
	>=dev-perl/Params-ValidationCompiler-0.130.0
	>=virtual/perl-Scalar-List-Utils-1.450.0
	>=dev-perl/Specio-0.150.0
	>=dev-perl/namespace-autoclean-0.190.0
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
		dev-perl/IPC-System-Simple
		dev-perl/Path-Tiny
		dev-perl/Test-File-ShareDir
		>=virtual/perl-Test-Simple-1.302.15
		dev-perl/Test2-Plugin-NoWarnings
	)
"
