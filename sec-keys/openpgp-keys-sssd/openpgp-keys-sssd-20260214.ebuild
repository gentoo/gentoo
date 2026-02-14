# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	C13CD07FFB2DB1408E457A3CD3D21B2910CF6759:sssd:openpgp,ubuntu,manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by sssd"
HOMEPAGE="https://sssd.io/"
SRC_URI+=" https://raw.githubusercontent.com/SSSD/sssd/refs/heads/master/contrib/pubkey.asc -> sssd-${PV}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
