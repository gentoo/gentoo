# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	CA262C6C83DE4D2FB28A332A3A6A4DB839EAA6D7:aacid:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Albert Astals Cid"
HOMEPAGE="https://poppler.freedesktop.org/"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
