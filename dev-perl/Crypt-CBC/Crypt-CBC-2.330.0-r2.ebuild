# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LDS
DIST_VERSION=2.33
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Encrypt Data with Cipher Block Chaining Mode"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Digest-MD5-2.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Crypt-Blowfish
		dev-perl/Crypt-DES
		dev-perl/Crypt-IDEA
		dev-perl/Crypt-Rijndael
	)
"
