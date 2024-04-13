# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by the strace project"
HOMEPAGE="https://strace.io/"
SRC_URI="
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x296d6f29a020808e8717a8842db5bd89a340aeb7
		-> ${P}-ldv.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - strace.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
