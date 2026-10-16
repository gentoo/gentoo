# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'FA26CA784BE188927F22B99F6570EA01146F7354:ileanadumitrescu95:github,openpgp,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the zvbi developer"
HOMEPAGE="https://github.com/zapping-vbi/zvbi"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
