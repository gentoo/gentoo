# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MRSCOTTY
DIST_VERSION=0.55
inherit perl-module

DESCRIPTION="Parse a X.509 certificate"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	>=dev-perl/Convert-ASN1-0.190.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.960.0 )
"
