# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	2F61B4828BBA779AECB3F32703A2A4AB1E32FD34:marlam:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Martin Lambers"
HOMEPAGE="https://marlam.de/msmtp/contact/"
SRC_URI="https://marlam.de/key.txt -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
