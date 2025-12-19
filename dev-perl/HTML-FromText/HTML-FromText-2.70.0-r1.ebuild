# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=2.07
inherit perl-module

DESCRIPTION="Convert plain text to HTML"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ~riscv x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Email-Find-0.90.0
	>=virtual/perl-Exporter-5.58
	>=dev-perl/HTML-Parser-1.260.0
	>=virtual/perl-Scalar-List-Utils-1.120.0
	>=virtual/perl-Text-Tabs+Wrap-98.112.800
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.960.0
	)
"
