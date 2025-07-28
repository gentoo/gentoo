# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=3.07
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Encrypt Data with Cipher Block Chaining Mode"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~ppc64 ~riscv ~sparc"

RDEPEND="
	dev-perl/CryptX
	dev-perl/Crypt-PBKDF2
	dev-perl/Crypt-URandom
	dev-perl/Math-Int128
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Crypt-Blowfish
		dev-perl/Crypt-DES
		dev-perl/Crypt-IDEA
		dev-perl/Crypt-Rijndael
	)
"
