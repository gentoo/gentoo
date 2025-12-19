# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LDS
DIST_VERSION=2.33
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Encrypt Data with Cipher Block Chaining Mode"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-perl/Crypt-Blowfish
		dev-perl/Crypt-DES
		dev-perl/Crypt-IDEA
		dev-perl/Crypt-Rijndael
	)
"
