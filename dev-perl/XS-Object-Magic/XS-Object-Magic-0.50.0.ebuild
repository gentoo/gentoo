# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Opaque, extensible XS pointer backed objects using sv_magic"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
	)
"
