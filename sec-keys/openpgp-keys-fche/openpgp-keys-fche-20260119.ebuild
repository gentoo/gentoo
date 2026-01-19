# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	C60CFE9F27405101D06DE3B86D8D01ADE253B252:fche:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Frank Ch. Eigler (fche)"
HOMEPAGE="https://web.elastic.org/~fche/index.shtml"
SRC_URI="https://web.elastic.org/~fche/gpg-public-key.asc -> ${P}-gpg-public-key.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
