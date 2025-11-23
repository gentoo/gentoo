# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Extract probable dates from strings"

SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Data-Inheritable
	>=dev-perl/DateTime-Format-Natural-0.600.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-MockTime-HiRes
		virtual/perl-Test-Simple
	)
"
