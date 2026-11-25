# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# openpgp, no user id
SEC_KEYS_VALIDPGPKEYS=(
	'6DAA6E64A76D2840571B4902528897B826403ADA:wernerkoch:manual,ubuntu'
	'AC8E115BF73E2D8D47FA9908E98E9B2D19C6C8BD:niibeyutaka:manual,ubuntu'
	'3B761AE4E63BF3519CE7D63BECB664CBE1332EEF:alexanderkulbartsch:manual,ubuntu'
	'02F38DFF731FF97CB039A1DA549E695E905BA208:gnupg2021:manual,ubuntu'
	'1493269DE61F124AA69A316E3ADF34EBDBB200A4:gnupg2026:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign GnuPG releases"
HOMEPAGE="https://gnupg.org/signature_key.html"
SRC_URI+=" https://gnupg.org/signature_key.asc -> ${P}-signature_key.asc"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
