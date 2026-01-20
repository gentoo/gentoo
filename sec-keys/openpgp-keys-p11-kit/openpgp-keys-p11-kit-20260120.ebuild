# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	462225C3B46F34879FC8496CD605848ED7E69871:zfridric:manual
	5D46CB0F763405A7053556F47A75A648B3F9220C:ueno:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used to sign p11-kit releases"
HOMEPAGE="https://p11-glue.github.io/p11-glue/p11-kit.html"
SRC_URI="https://p11-glue.github.io/p11-glue/p11-kit/p11-kit-release-keyring.gpg -> ${P}-p11-kit-release-keyring.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
