# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'D5823CACB477191CAC0075555AE420CC0209989E:alexeysokolov:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Alexey Sokolov"
HOMEPAGE="https://www.asokolov.org"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
