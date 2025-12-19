# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KENTNL
DIST_VERSION=5.07
inherit perl-module

DESCRIPTION="Library to manage HTML-Tree in PERL"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=dev-perl/HTML-Tagset-3.20.0
	>=dev-perl/HTML-Parser-3.460.0
	virtual/perl-Scalar-List-Utils
"
#	dev-perl/HTML-Format
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.800
	test? (
		virtual/perl-Encode
		dev-perl/Test-Fatal
		dev-perl/Test-LeakTrace
		virtual/perl-Test-Simple
		dev-perl/URI
	)
"
