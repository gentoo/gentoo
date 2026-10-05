# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by AppArmor"
HOMEPAGE="https://gitlab.com/apparmor"

# https://gitlab.com/apparmor/apparmor/-/wikis/6.0.0-alpha1_Signatures
SEC_KEYS_VALIDPGPKEYS=(
	3ECDCBA5FB34D254961CC53F6689E64E3D3664BB:apparmor:ubuntu
)

inherit sec-keys

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
