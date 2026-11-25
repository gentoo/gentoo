# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'2026E6A4A6A4483E61BA6F3FAB34BA0040E92ECE:stevehay:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP key used to sign Apache Perl releases"
HOMEPAGE="https://perl.apache.org/"
SRC_URI+=" https://people.apache.org/keys/committer/stevehay.asc -> ${P}-stevehay.asc"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
