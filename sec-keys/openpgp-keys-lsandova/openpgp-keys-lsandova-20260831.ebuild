# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'DFB62CC1A987E6C76EBF8143916EC0708CDFDDFD:lsandova:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP key for Leo Sandoval"
HOMEPAGE="https://gitlab.freedesktop.org/lsandova"
SRC_URI+=" https://gitlab.freedesktop.org/lsandova.gpg -> ${P}.gpg"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
