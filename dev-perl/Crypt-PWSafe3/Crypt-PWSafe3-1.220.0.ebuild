# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TLINDEN
DIST_VERSION=1.22
DIST_EXAMPLES=("sample/test.pl")
inherit perl-module

DESCRIPTION="Read and write Passwordsafe v3 files"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		>=dev-perl/Bytes-Random-Secure-0.90.0
	)
	>=dev-perl/Crypt-CBC-2.300.0
	>=dev-perl/Crypt-ECB-1.450.0
	>=dev-perl/Crypt-Random-1.250.0
	>=dev-perl/Crypt-Twofish-2.140.0
	>=dev-perl/Data-UUID-1.217.0
	>=dev-perl/Digest-HMAC-1.0.0
	>=virtual/perl-Digest-SHA-1.0.0
	virtual/perl-File-Temp
	>=dev-perl/Shell-0.500.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
