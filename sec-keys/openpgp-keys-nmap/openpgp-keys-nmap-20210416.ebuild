# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign Nmap releases"
HOMEPAGE="https://svn.nmap.org/nmap/docs/nmap_gpgkeys.txt"
SRC_URI="https://svn.nmap.org/nmap/docs/nmap_gpgkeys.txt -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - nmap.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
