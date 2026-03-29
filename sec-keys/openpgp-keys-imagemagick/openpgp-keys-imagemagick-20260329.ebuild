# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	D8272EF51DA223E4D05B466989AB63D48277377A:imagemagick:ubuntu
)
inherit sec-keys

DESCRIPTION="OpenPGP key used to sign ImageMagick releases"
# Linked in footer as "Public Key"
HOMEPAGE="https://imagemagick.org/script/install-source.php"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
