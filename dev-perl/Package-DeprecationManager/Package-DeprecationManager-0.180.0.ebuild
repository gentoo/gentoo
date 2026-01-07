# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="Manage deprecation warnings for your distribution"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Package-Stash
	dev-perl/Params-Util
	dev-perl/Sub-Install
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Warnings
	)
"
