# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
        D58529CC5376E36D6E1E6F6234F230FAF78E48D3:hclee:openpgp
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Hyunchul Lee (hclee)"
HOMEPAGE="https://github.com/hclee"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
