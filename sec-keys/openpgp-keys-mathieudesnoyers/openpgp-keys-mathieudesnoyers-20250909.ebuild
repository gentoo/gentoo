# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"2A0B4ED915F2D3FA45F5B16217280A9781186ACF:mathieudesnoyers:openpgp,ubuntu"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Mathieu Desnoyers"
HOMEPAGE="https://github.com/compudj"

KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
