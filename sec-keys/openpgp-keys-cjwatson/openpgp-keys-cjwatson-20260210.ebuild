# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# opengpg cannot be used due to missing user ID's
	AC0A4FF12611B6FCCF01C111393587D97D86500B:cjwatson:github,ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Colin Watson"
HOMEPAGE="https://github.com/cjwatson https://www.columbiform.co.uk/"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
