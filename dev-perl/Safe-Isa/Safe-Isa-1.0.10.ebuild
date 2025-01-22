# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.000010
inherit perl-module

DESCRIPTION="Call isa, can, does and DOES safely on things that may not be objects"

SLOT="0"
KEYWORDS="amd64 arm arm64 ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
