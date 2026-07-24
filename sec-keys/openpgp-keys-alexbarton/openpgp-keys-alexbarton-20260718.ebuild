# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	F5B9F52ED90920D2520376A2C24A0F637E364856:alexbarton1:ubuntu
	5F22A309911C1C6EFA1B69C1FE8B05CE1FA6365E:alexbarton2:ubuntu
)

DESCRIPTION="OpenPGP keys used by Alex Barton"
HOMEPAGE="https://github.com/alexbarton https://keybase.io/alexbarton"

inherit sec-keys

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
