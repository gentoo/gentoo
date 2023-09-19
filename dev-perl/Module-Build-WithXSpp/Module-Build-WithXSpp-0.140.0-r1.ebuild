# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SMUELLER
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="XS++ enhanced flavour of Module::Build"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	>=dev-perl/ExtUtils-CppGuess-0.40.0
	>=dev-perl/ExtUtils-XSpp-0.110.0
	virtual/perl-Digest-MD5
	virtual/perl-ExtUtils-CBuilder
	>=virtual/perl-ExtUtils-ParseXS-2.220.500
	>=dev-perl/Module-Build-0.260.0
"
BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"
