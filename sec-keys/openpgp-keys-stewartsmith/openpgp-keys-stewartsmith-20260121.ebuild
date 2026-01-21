# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	C17ED1F615E0795742AF1ACD537034284E0EFB7E:stewart:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Stewart Smith"
HOMEPAGE="https://www.flamingspork.com/"
SRC_URI="https://www.flamingspork.com/stewart.gpg -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
