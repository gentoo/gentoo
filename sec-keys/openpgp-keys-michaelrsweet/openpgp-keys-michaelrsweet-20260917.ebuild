# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'9086C3CDC66C3F563CF8F405BE67C75EC81F3244:msweet:openpgp'
	'845464660B686AAB36540B6F999559A027815955:old:openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Michael R Sweet"
HOMEPAGE="https://www.msweet.org/pgp.html"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
