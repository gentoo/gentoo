# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	0C9577FD2C4CFCB4B9A599640A30812EFF3AEFF5:smartmontools:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used to sign smartmontools releases"
HOMEPAGE="https://www.smartmontools.org/wiki/Download https://www.smartmontools.org/wiki/FAQ#check-signature"
SRC_URI="https://raw.githubusercontent.com/smartmontools/smartmontools/refs/heads/main/doc/old/SmartmontoolsSigningKey_2021.txt -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
