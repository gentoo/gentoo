# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"DC7F679B8A34DD606C1E54CAC4FC994D21532195:mongo-cxx-driver:manual"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by mongo-c-driver"
HOMEPAGE="https://pgp.mongodb.com/"
SRC_URI="
	https://pgp.mongodb.com/cpp-driver.pub -> ${P}.pub
"

KEYWORDS="~alpha amd64 ~arm64 ~hppa ~loong ~ppc ~riscv ~sparc x86"
