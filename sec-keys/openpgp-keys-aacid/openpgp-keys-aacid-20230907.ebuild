# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'CA262C6C83DE4D2FB28A332A3A6A4DB839EAA6D7:aacid:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Albert Astals Cid"
HOMEPAGE="https://poppler.freedesktop.org/"
# Mirrored from https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xca262c6c83de4d2fb28a332a3a6a4db839eaa6d7
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-0xCA262C6C83DE4D2FB28A332A3A6A4DB839EAA6D7.asc"

KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
