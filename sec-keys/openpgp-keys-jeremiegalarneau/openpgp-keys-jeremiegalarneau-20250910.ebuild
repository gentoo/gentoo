# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"7F49314A26E0DE78427680E05F1B2A0789F12B11:jeremiegalarneau:ubuntu"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Jérémie Galarneau"
HOMEPAGE="https://github.com/jgalar"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
