# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=KMX
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION='Digital Signature Algorithm using OpenSSL'
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"

RDEPEND="
	dev-libs/openssl:0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

DIST_TEST=do
# otherwise random fails occur
