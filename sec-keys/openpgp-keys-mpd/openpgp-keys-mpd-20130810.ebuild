# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'0392335A78083894A4301C43236E8A58C6DB4512:maxkellermann:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the Music Player Daemon developer"
HOMEPAGE="https://www.musicpd.org/"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
