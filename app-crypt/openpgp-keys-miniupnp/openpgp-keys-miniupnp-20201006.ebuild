# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign miniupnp* packages"
HOMEPAGE="http://miniupnp.free.fr/files/"
SRC_URI="
	http://miniupnp.free.fr/A31ACAAF.asc
	http://miniupnp.free.fr/A5C0863C.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - miniupnp.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}
