# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	D04526CE8C87436EBBC51588E0E355F76BE234CA:claws:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by mail-client/claws-mail"
HOMEPAGE="https://www.claws-mail.org/releases.php"
SRC_URI="https://www.claws-mail.org/keys/claws-mail-signing-key.asc -> claws-mail-signing-key-${PV}.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
