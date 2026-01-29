# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'EF0882079FD4ED32BF8B23B2A1B09EF84EDC5219:2.4:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by net-mail/dovecot"
HOMEPAGE="https://repo.dovecot.org/#source"
SRC_URI="https://repo.dovecot.org/DOVECOT-REPO-GPG-2.4"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
