# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'BE5C23209ACDDACEB20DB0A28C8189F1988C2166:dkiper:openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for GRUB releases"
HOMEPAGE="https://www.gnu.org/software/grub/"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
