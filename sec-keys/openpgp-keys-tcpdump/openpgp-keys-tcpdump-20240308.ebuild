# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign tcpdump releases"
HOMEPAGE="https://www.tcpdump.org/index.html#latest-releases"
SRC_URI="https://www.tcpdump.org/release/signing-key.asc -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - tcpdump.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
