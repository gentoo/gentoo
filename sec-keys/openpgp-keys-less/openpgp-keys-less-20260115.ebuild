# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'AE27252BD6846E7D6EAE1DD6F153A7C833235259:less:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by less"
HOMEPAGE="https://www.greenwoodsoftware.com/less/download.html"
SRC_URI="https://www.greenwoodsoftware.com/less/pubkey.asc -> ${P}.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
