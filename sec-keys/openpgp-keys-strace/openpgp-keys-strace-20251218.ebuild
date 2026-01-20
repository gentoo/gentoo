# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# https://github.com/strace/strace/commit/f798e04233c8f3be0b201c05c274303a8f28e314
	'7BECFE3AF7B280BB52FF77F104BA4521C996DDE1:strace:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by the strace project"
HOMEPAGE="https://strace.io/"
# GPG-KEY in strace.git
SRC_URI="https://raw.githubusercontent.com/strace/strace/f798e04233c8f3be0b201c05c274303a8f28e314/GPG-KEY -> ${P}-strace.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
