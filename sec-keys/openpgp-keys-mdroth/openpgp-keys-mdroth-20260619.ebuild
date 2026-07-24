# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	CEACC9E15534EBABB82D3FA03353C9CEF108B584:mdroth:openpgp,ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Michael Roth (mdroth)"
HOMEPAGE="https://github.com/mdroth https://gitlab.com/mdroth"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
