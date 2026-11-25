# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# https://networkupstools.org/docs/user-manual.chunked/NUT_Security.html#verifySourceSig

SEC_KEYS_VALIDPGPKEYS=(
	'137107DF3CF391607905144BDB6414CA204DDF1B:aquette1:manual,ubuntu'
	# OpenPGP misses user ID
	'35610CB997C2245289817328ACC0E41055CA5976:aquette2:manual,ubuntu'
	'B83459F776B90224988F36C0DE0184DA7043DCF7:jimklimov:manual,ubuntu,openpgp'
)
inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign NUT"
HOMEPAGE="https://networkupstools.org"
SRC_URI+="
	https://networkupstools.org/source/nut-key.gpg -> ${P}-nut-key.pgp
"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
