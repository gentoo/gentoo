# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gentoo Authority Keys (GLEP 79)"
HOMEPAGE="https://www.gentoo.org/downloads/signatures/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/openpgp-keys/gentoo-auth.asc.${PV}.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"

S=${WORKDIR}

src_install() {
	insinto /usr/share/openpgp-keys
	newins "gentoo-auth.asc.${PV}" gentoo-auth.asc
	newins - gentoo-auth-ownertrust.txt <<-EOF
		ABD00913019D6354BA1D9A132839FE0D796198B1:6:
	EOF
}
