# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EHUELS
DIST_VERSION=2.1700
inherit perl-module

DESCRIPTION="Perl SASL interface"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="kerberos"

RDEPEND="
	dev-perl/Digest-HMAC
	virtual/perl-Digest-MD5
	kerberos? ( dev-perl/GSSAPI )
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.42
	test? (
		virtual/perl-Test-Simple
	)
"
