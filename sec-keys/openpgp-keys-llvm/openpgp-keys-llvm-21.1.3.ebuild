# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# linked PGP key file misses necessary keys
SEC_KEYS_VALIDPGPKEYS=(
	'474E22316ABF4785A88C6E8EA2C794A986419D8A:tstellar:ubuntu'
	'D574BD5D1D0E98895E3BF90044F2485E45D59042:tobiashieta:ubuntu'
	'FFB3368980F3E6BB5737145A316C56D064CACBA5:douglas.yung:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign LLVM releases"
HOMEPAGE="https://github.com/llvm/llvm-project/releases/tag/llvmorg-21.1.3/"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
