# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	BF5A669F2272CF4324C1FDA8CFB4C2166397D0D2:keepassxc:manual,openpgp,ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used for KeePassXC releases"
HOMEPAGE="https://keepassxc.org/verifying-signatures/"
SRC_URI+="
	https://keepassxc.org/keepassxc_master_signing_key.asc
		-> ${P}-keepassxc.org.asc
"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
