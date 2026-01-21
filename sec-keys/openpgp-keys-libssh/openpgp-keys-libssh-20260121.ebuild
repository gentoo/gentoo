# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	88A228D89B07C2C77D0C780903D5DF8CFDD3E8E7:libssh:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by net-libs/libssh"
HOMEPAGE="https://www.libssh.org/get-it/"
SRC_URI="https://www.libssh.org/files/0x03D5DF8CFDD3E8E7_libssh_libssh_org_gpgkey.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
