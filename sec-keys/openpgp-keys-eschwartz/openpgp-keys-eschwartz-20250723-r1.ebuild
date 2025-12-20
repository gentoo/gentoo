# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'BD27B07A5EF45C2ADAF70E0484818A6819AF4A9B:eli-schwartz:github'
	'EF51D308B1CE230888BE0D84EA423E93A16343F1:eli-schwartz2:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Eli Schwartz"
HOMEPAGE="https://github.com/eli-schwartz"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
