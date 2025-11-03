# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"6DB55D8223FF44E49DCB981344E76C0565ABC463:mongo-c-driver:manual"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by mongo-c-driver"
HOMEPAGE="https://pgp.mongodb.com/"
SRC_URI="
	https://pgp.mongodb.com/c-driver.pub -> ${P}.pub
"

KEYWORDS="~alpha amd64 ~arm64 ~hppa ~loong ~ppc ~riscv ~sparc x86"
