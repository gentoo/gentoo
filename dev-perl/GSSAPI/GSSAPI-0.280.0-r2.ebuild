# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=AGROLMS
DIST_VERSION=0.28
inherit perl-module

DESCRIPTION="Perl extension providing access to the GSSAPIv2 library"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/krb5
"
BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"
DEPEND="${RDEPEND}
"
