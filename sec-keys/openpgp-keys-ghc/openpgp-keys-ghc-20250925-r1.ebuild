# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign GHC releases"
HOMEPAGE="https://www.haskell.org/ghc"

# To check who signed each version, look at the installation page
# Example: <https://www.haskell.org/ghc/download_ghc_9_8_2.html#binaries>
#
# NOTE: The installation page for 9.6.3 says it was signed by Bryan Richter,
# but the key has no user ID (33C3A599DB85EA9B8BAA1866B202264020068BFB).

SEC_KEYS_VALIDPGPKEYS=(
	# Ben Gamari <ben@well-typed.com>
	'FFEB7CE81E16A36B3E2DED6F2DE04D4E97DB64AD:bgamari:openpgp'
	# Zubin Duggal <zubin@well-typed.com>
	'88B57FCF7DB53B4DB3BFA4B1588764FBE22D19C4:zduggal:openpgp'
	# Luite Stegeman <stegeman@gmail.com>
	'8C961469C8FDC968718D6245AC7DE836C5DF907D:lstegeman:openpgp'
)

inherit sec-keys

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
