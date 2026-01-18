# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	CDAC41B9122470FAF357A9D344448A298D5C3618:streamlink:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for streamlink releases"
HOMEPAGE="https://streamlink.github.io/install.html#source-distribution"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
