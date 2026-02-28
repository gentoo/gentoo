# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"231018690C4D903EF419146AA144323DEAACDF45:nlnetlabs:openpgp"
)

inherit sec-keys

DESCRIPTION="NLnet Labs releases signing key G2"
HOMEPAGE="https://www.nlnetlabs.nl/projects/nsd/download/"
SRC_URI="https://www.nlnetlabs.nl/downloads/keys/releases-g2.asc"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
