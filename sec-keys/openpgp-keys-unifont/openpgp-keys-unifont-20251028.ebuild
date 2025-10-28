# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'95D2E9AB8740D8046387FD151A09227B1F435A33:unifont:ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Unifont"
HOMEPAGE="https://unifoundry.com/unifont/index.html"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
