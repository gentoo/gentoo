# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	168E6F4297BFD7A79AFD4496514BBE2EB8E1961F:benno:openpgp
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Frank Ch. Eigler (fche)"
HOMEPAGE="https://web.elastic.org/~fche/index.shtml"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
