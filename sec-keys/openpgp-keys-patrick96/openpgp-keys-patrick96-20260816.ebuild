# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Patrick Ziegler"
HOMEPAGE="https://www.patrickziegler.ch"
SRC_URI="
	https://www.patrickziegler.ch/mykey.asc -> patrick96-${PV}-1D5791352D51A228D4DDDBA4521E5E03AEBCA1A7.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - patrick96.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
