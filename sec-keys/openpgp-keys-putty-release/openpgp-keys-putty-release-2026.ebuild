# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"1A07DAC0F220CF12248EA7195C67D0F88BC3E5B5:sgtatham:manual"
)

inherit sec-keys

DESCRIPTION="PuTTY Release Key"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/putty/keys.html"
SRC_URI="https://www.chiark.greenend.org.uk/~sgtatham/putty/keys/release-${PV}.asc"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
