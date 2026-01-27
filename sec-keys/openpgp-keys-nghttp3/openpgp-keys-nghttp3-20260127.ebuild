# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	F4F3B91474D1EB29889BD0EF7E8403D5D673C366:tatsuhiro-t:github
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by net-libs/nghttp3"
HOMEPAGE="https://github.com/tatsuhiro-t"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
