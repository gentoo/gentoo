# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'7BECFE3AF7B280BB52FF77F104BA4521C996DDE1:pam:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the linux-pam project"
HOMEPAGE="https://github.com/linux-pam/linux-pam"
SRC_URI="https://github.com/linux-pam/linux-pam/raw/refs/tags/v1.7.2/pgp.keys.asc -> ${P}.asc"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
