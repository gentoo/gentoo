# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"E57235D22764129FA4F2F4D17F52608ED0E49D76:ntpsec:ubuntu"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign ntpsec releases"
HOMEPAGE="https://ftp.ntpsec.org/pub/releases/"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
