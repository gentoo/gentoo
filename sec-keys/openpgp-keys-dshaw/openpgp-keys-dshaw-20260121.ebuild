# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# Need Ubuntu for subkeys
	7D92FD313AB6F3734CC59CA1DB698D7199242560:dshaw:manual,ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by David Shaw"
HOMEPAGE="https://www.jabberwocky.com/software/"
# PGP key is at the end
SRC_URI+=" https://raw.githubusercontent.com/dmshaw/paperkey/ce2666fab55309a179060c069c380fc2fbae04ff/README -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
