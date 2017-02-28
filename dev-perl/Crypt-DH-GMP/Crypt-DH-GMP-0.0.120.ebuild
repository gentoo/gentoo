# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DMAKI
DIST_VERSION=0.00012
inherit perl-module

DESCRIPTION="Crypt::DH Using GMP Directly"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-XSLoader-0.20.0
	>=dev-libs/gmp-4.0.0:0
"
DEPEND="${RDEPEND}
	>=dev-perl/Devel-CheckLib-0.400.0
	>=virtual/perl-Devel-PPPort-3.190.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-ExtUtils-ParseXS-3.180.0
	test? (
		dev-perl/Test-Requires
		virtual/perl-Test-Simple
	)
"
