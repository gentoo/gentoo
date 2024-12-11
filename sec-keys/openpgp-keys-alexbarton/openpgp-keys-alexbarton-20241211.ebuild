# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Alex Barton"
HOMEPAGE="https://github.com/alexbarton https://keybase.io/alexbarton"
SRC_URI="
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xF5B9F52ED90920D2520376A2C24A0F637E364856
		-> F5B9F52ED90920D2520376A2C24A0F637E364856.asc
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x5F22A309911C1C6EFA1B69C1FE8B05CE1FA6365E
		-> 5F22A309911C1C6EFA1B69C1FE8B05CE1FA6365E.asc
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	newins - alexbarton.asc < <(
		for x in ${A}; do
			cat "${DISTDIR}/${x}"
		done
	)
}
