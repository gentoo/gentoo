# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.20171012
inherit perl-module

DESCRIPTION="Attempt to recover from people calling UNIVERSAL::isa as a function"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"
