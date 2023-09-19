# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PLICEASE
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Alien wrapper for OpenSSL"

SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-perl/Alien-Build-0.38.0
	dev-perl/Mozilla-CA
	dev-libs/openssl:=
"
DEPEND="
	dev-libs/openssl:=
"
BDEPEND="${RDEPEND}
	>=dev-perl/Alien-Build-1.190.0
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	test? (
		>=dev-perl/Test2-Suite-0.0.121
	)
"
