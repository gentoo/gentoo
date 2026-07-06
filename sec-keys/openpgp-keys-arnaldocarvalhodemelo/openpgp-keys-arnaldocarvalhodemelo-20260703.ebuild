# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYRING_COMMIT="a180d237a0d1914531072872543a50af04956896"

SEC_KEYS_VALIDPGPKEYS=(
	'2DBF5BAA46FB4DED338A335BD65016F35352AA40:acme:manual,ubuntu,openpgp'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys of Arnaldo Carvalho de Melo"
HOMEPAGE="https://www.kernel.org/signature.html"
SRC_URI+=" https://git.kernel.org/pub/scm/docs/kernel/pgpkeys.git/plain/keys/D65016F35352AA40.asc?id=${KEYRING_COMMIT} -> ${P}.asc"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
