# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DROLSKY
DIST_VERSION=1.26
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Localization support for DateTime"

LICENSE="|| ( Artistic GPL-1+ ) unicode"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Dist-CheckConflicts-0.20.0
	virtual/perl-Exporter
	dev-perl/File-ShareDir
	>=dev-perl/Params-ValidationCompiler-0.130.0
	>=virtual/perl-Scalar-List-Utils-1.450.0
	>=dev-perl/Specio-0.150.0
	>=dev-perl/namespace-autoclean-0.190.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		virtual/perl-CPAN-Meta-Requirements
		>=dev-perl/CPAN-Meta-Check-0.11.0
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/IPC-System-Simple
		virtual/perl-Storable
		dev-perl/Test-Fatal
		dev-perl/Test-File-ShareDir
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Warnings
	)
"
